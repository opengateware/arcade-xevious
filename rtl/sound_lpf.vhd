---------------------------------------------------------------------------------
-- Galaga audio lpf filters based on Burnin' Rubber sources
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all,
    ieee.std_logic_1164.all,
    ieee.std_logic_unsigned.all,
    ieee.numeric_std.all;

entity lpf is
port(
	clock        : in std_logic;
	reset        : in std_logic;

	div          : in integer;
	audio_in     : in std_logic_vector(9 downto 0);

	gain_in      : in integer;
	r1           : in integer;
	r2           : in integer;
	dt_over_c3    : in integer;
	dt_over_c4    : in integer;
	r5           : in integer;

	audio_out    : out std_logic_vector(15 downto 0)
);
end lpf;

architecture rtl of lpf is
signal clock_div     : std_logic_vector(9 downto 0) := (others =>'0');

signal uin  : integer range -256 to 255;
signal u3   : integer range -32768 to 32767;
signal u4   : integer range -32768 to 32767;
signal du3  : integer range -32768*4096 to 32767*4096;
signal du4  : integer range -32768*4096 to 32767*4096;

signal uout : integer range -32768 to 32767;
signal uout_lim : integer range -128 to 127;

-- integer scale for fixed point
constant scale   : integer := 8192;
begin

--                 ----------o------------
--            u4^  |         |           |
--              | --- C4    | | R5       |
--              | ---       | |          |
--              |  |    C3   |           |
--     --| R1 |----o----||---o------|\   |
--     ^           |  ------> u3    | \__o---
--     |           |                | /     ^
--     |uin       | | R2          --|/      |
--     |          | |             |         | uout
--     |           |              |         |
--     ------------o--------------o----------
--
--
-- i1 = (sin+u3)/R1
-- i2 = -u3/R2
-- i3 = (u4-u3)/R5
-- i4 = i2-i1-i3
--
-- u3(t+dt) = u3(t) + i3(t)*dt/C3;
-- u4(t+dt) = u4(t) + i4(t)*dt/C4;

-- uout = u4-u3

-- dt = 1/f_ech = 1/23437
-- dt/C3 = dt/C4 = 4267

-- LPF 1 calculations
--
-- R1 = 150000;
-- R2 = 22000;
-- C3 = 0.01e-6;
-- C4 = 0.01e-6;
-- R5 = 470000;
--
-- (i3(t)*dt/C3)*scale = du3*scale = ((u4-u3)/470000*4267)*scale
--                               = (u4-u3)*11
--
-- (i4(t)*dt/C4)*scale = du4*scale = (-u3/22000 -(uin+u3)/150000 -(u4-u3)/470000)*4267*scale
--                               = -u3*(233+34-11) - uin*34 - u4*11
--                               = -(u4*11 + u3*256 + uin*34)

-- LPF 2 calculations
--
-- R1 = 47000;
-- R2 = 10000;
-- C3 = 0.01e-6;
-- C4 = 0.01e-6;
-- R5 = 150000;
--
-- (i3(t)*dt/C3)*scale = du3*scale = ((u4-u3)/150000*4267)*scale
--                               = (u4-u3)*34
--
-- (i4(t)*dt/C4)*scale = du4*scale = (-u3/10000 -(uin+u3)/47000 -(u4-u3)/150000)*4267*scale
--                               = -u3*(514+109-34) - uin*109 - u4*34
--                               = -(u4*34 + u3*589 + uin*109)


uin <= to_integer(unsigned(audio_in)-128)*gain_in;

process (clock)
begin
	if reset = '1' then
		clock_div <= (others => '0');
	else
		if rising_edge(clock) then
			-- divide 18 MHz clock by 768 = 23.437kHz downsampling
			--if clock_div = div-1 then -- "1011111111" then
			if clock_div = "1011111111" then
				clock_div <= "0000000000";
			else
				clock_div <= clock_div + '1';
			end if;

			if clock_div = "0000000000" then
                        	du3 <= u4*109 - u3*109;
                        	du4 <= u4*109 + u3*1432 + uin*1027;
			--  	du3 <= (u4-u3)*scale*dt_over_c3/r5;
			-- 	du4 <= u3*(scale*dt_over_c4/r2+scale*dt_over_c4/r1-scale*dt_over_c4/r5)
			-- 	       + u4*scale*dt_over_c4/r5
			-- 	       + uin*scale*dt_over_c4/r1;

			-- 	du4 <= -u3*scale*dt_over_c4/r2
			-- 	       -(uin+u3)*scale*dt_over_c4/r1
			-- 	       -(u4-u3)*scale*dt_over_c4/r5;
			end if;

			if clock_div = "0000000001" then
				u3 <= u3 + du3/scale;
				u4 <= u4 - du4/scale;
			end if;

			if clock_div = "0000000010" then
				uout <= (u4 - u3) / 2; -- adjust output gain
			end if;

			-- clamp
			if clock_div = "0000000011" then
				if uout > 127 then
					uout_lim <= 127;
				elsif uout < -127 then
					uout_lim <= -127;
				else
					uout_lim <= uout;
				end if;
			end if;

			if clock_div = "0000000100" then
				-- audio_out <= std_logic_vector(to_unsigned(uout,10));
				audio_out <= "0"&std_logic_vector(to_unsigned(uout_lim+128,8)) & "0000000";
			end if;
		end if;
	end if;
end process;

end architecture;
