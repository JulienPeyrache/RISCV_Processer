library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PKG.all;

entity CPU_CND is
    generic (
        mutant      : integer := 0
    );
    port (
        ina         : in w32; -- c'est rs1
        inb         : in w32; -- c'est rs2
        f           : in  std_logic; -- c'est IR(14)
        r           : in  std_logic; -- c'est IR(13)
        e           : in  std_logic; -- c'est IR(12)
        d           : in  std_logic; -- c'est IR(6)
        s           : out std_logic; -- c'est SLT
        j           : out std_logic -- c'est status.JCOND
    );
end entity;

architecture RTL of CPU_CND is

    SIGNAL sub: w32;
	SIGNAl ext_sign : std_logic;
	SIGNAl z : std_logic;
	SIGNAl s_out : std_logic;
	CONSTANT null_vec_33 : signed(32 downto 0) := (others => '0');
	SIGNAl A, B, sub_signed: signed(32 downto 0);


begin  
    idk : process(all)
	begin
    ext_sign <= (not(e) and not(d)) or (d and not(r));

	if ext_sign = '0' then
		A <= signed('0' & ina);
		B <= signed('0' & inb);
		sub_signed <= A - B;
		s_out <= sub_signed(32);
		if sub_signed = null_vec_33 then
			z <= '1';
		else
			z <= '0';
		end if;
	else
		sub <= ina - inb;
		s_out <= sub(31);
		if sub = w32_zero then
			z <= '1';
		else
			z <= '0';
		end if;
	end if;
	
	s <= s_out;


    j <= (f and (e xor s_out)) or (not(f) and (e xor z));
	
	end process idk;




end architecture;
