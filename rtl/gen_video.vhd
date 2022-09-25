---------------------------------------------------------------------------------
-- Xevious video horizontal/vertical and sync generator by Dar (darfpga@aol.fr)
-- http://darfpga.blogspot.fr
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all,
    ieee.std_logic_1164.all,
    ieee.std_logic_unsigned.all,
    ieee.numeric_std.all;


entity gen_video is
port(
	clk     : in std_logic;
	enable  : in std_logic;
	hcnt    : out std_logic_vector(8 downto 0);
	vcnt    : out std_logic_vector(8 downto 0);
	hsync   : out std_logic;
	vsync   : out std_logic;
	csync   : out std_logic; -- composite sync for TV 
	blank_h : out std_logic;
	blank_v : out std_logic;
	blankn  : out std_logic;
	h_offset: in signed(3 downto 0);
	v_offset: in signed(3 downto 0)
);
end gen_video;

architecture struct of gen_video is
signal hclkReg : unsigned (1 DOWNTO 0);
signal hblank  : std_logic;
signal vblank  : std_logic;
signal hcntReg : unsigned (8 DOWNTO 0) := to_unsigned( 0, 9);
signal vcntReg : unsigned (8 DOWNTO 0) := to_unsigned(15, 9);

signal hsync0  : std_logic;
signal hsync1  : std_logic;
signal hsync2  : std_logic;

signal hsync_base : integer;
signal vsync_base : integer;
begin

blank_h <= hblank;
blank_v <= vblank;

hcnt  <= std_logic_vector(hcntReg);
vcnt  <= std_logic_vector(vcntReg);
hsync <= not hsync0;

-- Compteur horizontal : 511-128+1=384 pixels (48 tiles)
-- 128 à 191 :  64 pixels debut de ligne  (8 dont 2 dernières tiles affichées)
-- 192 à 447 : 256 pixels centre de ligne (32 tiles affichées)
-- 448 à 511 :  64 pixels fin de ligne    (8 dont 2 premières tiles affichées)

-- Compteur vertical   : 263-000+1=264 lignes (33 tiles)
-- 000 à 015 :  16 lignes debut de trame  (2 tiles)
-- 016 à 239 : 224 lignes centrales       (28 tiles affichées)
-- 240 à 263 :  24 lignes fin de trame    (3 tiles)

--- Synchro horizontale : hcnt=[495-511/128-140] (29 pixels)
--- Synchro verticale   : vcnt=[260-263/000-003] ( 8 lignes)

process(clk)
begin
	if rising_edge(clk) then
		if enable = '1' then    -- clk & ena at 6MHz

		if hcntReg = 511 then
			hcntReg <= to_unsigned (128,9);
			if vcntReg = 263 then
				vcntReg <= to_unsigned(0,9);
			else
				vcntReg <= vcntReg + 1;
			end if;
		else
			hcntReg <= hcntReg + 1;
		end if;

		hsync_base <= 495 + to_integer(resize(h_offset, 9));
		if    hcntReg = (hsync_base)        then hsync0 <= '0'; -- 1
		elsif hcntReg = (hsync_base+29-384) then hsync0 <= '1';
		end if;

		if    hcntReg = (hsync_base)            then hsync1 <= '0';
		elsif hcntReg = (hsync_base+13)         then hsync1 <= '1'; -- 11
		elsif hcntReg = (hsync_base   +192-384) then hsync1 <= '0';
		elsif hcntReg = (hsync_base+13+192-384) then hsync1 <= '1'; -- 11
		end if;

		if    hcntReg = (hsync_base)    then hsync2 <= '0';
		elsif hcntReg = (hsync_base-28) then hsync2 <= '1';
		end if;

		vsync_base <= 250+to_integer(resize(v_offset, 9));
		if     vcntReg = (vsync_base+ 2-1+2) mod 264 then csync <= hsync1;
		elsif  vcntReg = (vsync_base+ 3-1+2) mod 264 then csync <= hsync1;
		elsif  vcntReg = (vsync_base+ 4-1+2) mod 264 then csync <= hsync1; -- and hsync2;
		elsif  vcntReg = (vsync_base+ 5-1+2) mod 264 then csync <= hsync2; -- not(hsync1);
		elsif  vcntReg = (vsync_base+ 6-1+2) mod 264 then csync <= hsync2; -- not(hsync1);
		elsif  vcntReg = (vsync_base+ 7-1+2) mod 264 then csync <= hsync2; -- not(hsync1) or not(hsync2);
		elsif  vcntReg = (vsync_base+ 8-1+2) mod 264 then csync <= hsync1;
		elsif  vcntReg = (vsync_base+ 9-1+2) mod 264 then csync <= hsync1;
		elsif  vcntReg = (vsync_base+10-1+2) mod 264 then csync <= hsync1;
		else                          csync <= hsync0;
		end if;

		if    vcntReg = (vsync_base+10) mod 264 then vsync <= '1';
		elsif vcntReg = (vsync_base+17) mod 264 then vsync <= '0';
		end if;

		if    hcntReg = (448+16+8+1) then hblank <= '1';
		elsif hcntReg = (192-16+8+1) then hblank <= '0';
		end if;

		if    vcntReg = (240+2) then vblank <= '1';
		elsif vcntReg = (016+2) then vblank <= '0';
		end if;

		blankn <= not (hblank or vblank);
		end if;
	end if;
end process;

end architecture;
