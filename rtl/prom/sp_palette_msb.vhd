library ieee;
use ieee.std_logic_1164.all, ieee.numeric_std.all;

entity sp_palette_msb is
    port (
        clk  : in std_logic;
        addr : in std_logic_vector(8 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end entity;

architecture prom of sp_palette_msb is
    type rom is array(0 to 511) of std_logic_vector(7 downto 0);
    signal rom_data : rom := (
        X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"08", X"08", X"0A", X"08", X"0C", X"0A", X"0E",
        X"00", X"0A", X"08", X"0E", X"0E", X"0B", X"0E", X"0E", X"00", X"0A", X"08", X"0E", X"0E", X"0B", X"0E", X"0E",
        X"00", X"0C", X"08", X"0E", X"0E", X"0B", X"0E", X"0E", X"00", X"0C", X"08", X"0E", X"0E", X"0B", X"0E", X"0E",
        X"00", X"08", X"08", X"0E", X"0E", X"0B", X"0E", X"0E", X"00", X"0B", X"08", X"0A", X"08", X"0C", X"08", X"0A",
        X"00", X"0B", X"08", X"0A", X"08", X"0C", X"08", X"0A", X"00", X"0B", X"08", X"0A", X"08", X"0C", X"08", X"0C",
        X"00", X"0B", X"08", X"0A", X"08", X"0C", X"08", X"0D", X"00", X"0B", X"08", X"0A", X"08", X"0C", X"08", X"08",
        X"00", X"08", X"08", X"0B", X"0B", X"0E", X"0A", X"0C", X"00", X"0E", X"0E", X"0E", X"08", X"0D", X"08", X"0A",
        X"00", X"0A", X"0B", X"00", X"00", X"00", X"00", X"00", X"00", X"0B", X"00", X"00", X"00", X"00", X"00", X"00",
        X"00", X"0A", X"08", X"0B", X"00", X"00", X"00", X"00", X"00", X"0A", X"08", X"0B", X"00", X"00", X"00", X"00",
        X"00", X"0C", X"08", X"0B", X"00", X"00", X"00", X"00", X"00", X"0C", X"08", X"0B", X"00", X"00", X"00", X"00",
        X"00", X"08", X"08", X"0B", X"00", X"00", X"00", X"00", X"00", X"0A", X"0C", X"0C", X"0D", X"0D", X"08", X"0A",
        X"00", X"0E", X"0E", X"0E", X"0F", X"0F", X"08", X"0E", X"00", X"0B", X"0F", X"0F", X"0F", X"0F", X"00", X"0B",
        X"00", X"0E", X"0C", X"0C", X"0F", X"0F", X"08", X"0E", X"00", X"0C", X"0F", X"0F", X"0F", X"0F", X"08", X"0C",
        X"00", X"0B", X"0F", X"0F", X"0F", X"0F", X"00", X"0B", X"00", X"0E", X"0F", X"0F", X"0F", X"0F", X"00", X"0E",
        X"00", X"0E", X"0F", X"0F", X"0F", X"0F", X"08", X"0E", X"00", X"0B", X"08", X"0E", X"0E", X"0B", X"0E", X"0E",
        X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
        X"00", X"08", X"0C", X"08", X"00", X"00", X"00", X"00", X"00", X"08", X"00", X"08", X"00", X"00", X"00", X"00",
        X"00", X"0E", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"0B", X"0A", X"0C", X"00", X"00", X"00", X"00",
        X"00", X"08", X"0A", X"0C", X"00", X"00", X"00", X"00", X"00", X"0B", X"0A", X"00", X"00", X"00", X"00", X"00",
        X"00", X"0A", X"0B", X"00", X"00", X"00", X"00", X"00", X"00", X"0B", X"0C", X"00", X"00", X"00", X"00", X"00",
        X"00", X"0C", X"0B", X"00", X"00", X"00", X"00", X"00", X"00", X"08", X"0C", X"0A", X"00", X"00", X"00", X"00",
        X"00", X"08", X"00", X"0A", X"00", X"00", X"00", X"00", X"00", X"08", X"08", X"0E", X"00", X"00", X"00", X"00",
        X"00", X"0A", X"0C", X"08", X"00", X"00", X"00", X"00", X"00", X"0B", X"08", X"08", X"0A", X"08", X"0C", X"0E",
        X"00", X"0B", X"08", X"08", X"0F", X"0F", X"0E", X"00", X"00", X"0B", X"0F", X"0F", X"0D", X"0D", X"0F", X"0A",
        X"00", X"0D", X"0A", X"0A", X"08", X"0A", X"08", X"0C", X"00", X"0D", X"0D", X"0A", X"0E", X"0D", X"08", X"08",
        X"00", X"0A", X"09", X"0E", X"0F", X"0E", X"08", X"08", X"00", X"0B", X"0A", X"0C", X"0D", X"08", X"0A", X"08",
        X"00", X"0A", X"0C", X"0C", X"0B", X"0D", X"08", X"0A", X"00", X"0B", X"0D", X"08", X"0A", X"0C", X"0A", X"0A",
        X"00", X"0D", X"08", X"0A", X"08", X"0C", X"0A", X"0A", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
        X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
        X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
        X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
        X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00");
begin
    process (clk)
    begin
        if rising_edge(clk) then
            data <= rom_data(to_integer(unsigned(addr)));
        end if;
    end process;
end architecture;
