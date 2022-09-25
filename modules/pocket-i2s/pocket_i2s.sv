//------------------------------------------------------------------------------
// Generic I2S audio interface for the Analogue Pocket
//------------------------------------------------------------------------------
module pocket_i2s
    (
        input                  iCLK_74,
        input       [BITS-1:0] AUDIO_L,
        input       [BITS-1:0] AUDIO_R,

        output wire            I2S_MCLK,
        output wire            I2S_DAC,
        output wire            I2S_LRCK
    );

    parameter BITS = 16;
    parameter STEREO = 0;
    parameter SIGNED = 0;

    localparam [20:0] CYCLE_48KHZ = 21'd122880 * 2;

    wire [BITS-1:0] audio_left = ~SIGNED ? AUDIO_L : {~AUDIO_L[BITS-1],AUDIO_L[BITS-2:0]};
    wire [BITS-1:0] audio_right = STEREO ? ~SIGNED ? AUDIO_R : {~AUDIO_R[BITS-1],AUDIO_R[BITS-2:0]} : audio_left;

    assign I2S_MCLK = audio_mclk;
    assign I2S_DAC  = audio_dac;
    assign I2S_LRCK = audio_lrck;

    // Generate MCLK = 12.288mhz with fractional accumulator
    reg [21:0] audio_accum;
    reg        audio_mclk;
    always @(posedge iCLK_74) begin
        audio_accum <= audio_accum + CYCLE_48KHZ;
        if(audio_accum >= 21'd742500) begin
            audio_mclk <= ~audio_mclk;
            audio_accum <= audio_accum - 21'd742500 + CYCLE_48KHZ;
        end
    end

    // Generate SCLK = 3.072mhz by dividing MCLK by 4
    reg [1:0]   aud_mclk_divider;
    wire        audio_sclk = aud_mclk_divider[1] /* synthesis keep*/;
    reg         audio_lrck_1;
    always @(posedge audio_mclk) begin
        aud_mclk_divider <= aud_mclk_divider + 1'b1;
    end

    // Synchronize audio samples coming from the core
    wire [31:0] audio_sampledata_s;
    synch_3 #(.WIDTH(32)) sync_snd({audio_left, audio_right} ,audio_sampledata_s, audio_sclk);

    reg  [31:0] audio_sampshift;
    reg  [4:0]  audio_lrck_cnt;
    reg         audio_lrck;
    reg         audio_dac;
    reg         audio_nextsamp;
    always @(negedge audio_sclk) begin
        audio_nextsamp <= 0;
        // Output the next bit
        audio_dac <= audio_sampshift[31];
        // 48khz * 64
        audio_lrck_cnt <= audio_lrck_cnt + 1'b1;
        if (audio_lrck_cnt == 31) begin
            // switch channels
            audio_lrck <= ~audio_lrck;

            // Reload sample shifter
            if (~audio_lrck) begin
                audio_sampshift <= audio_sampledata_s;
            end
        end
        else if (audio_lrck_cnt < 16) begin
            // only shift for 16 clocks per channel
            audio_sampshift <= {audio_sampshift[30:0], 1'b0};
        end
    end

endmodule
