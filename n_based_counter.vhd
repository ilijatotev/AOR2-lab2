--malo je ocajno formatirano jer sam kopirao sa wa ali bare with me


-- Code your design here

library IEEE;

use IEEE.std_logic_1164.all;


entity ctr is

generic(n: integer := 8);

port(
clk,clr,ce,wr: in bit;

din: in integer range 0 to 127;

dout: out integer range 0 to 127);

end entity;



architecture arch of ctr is

begin

process(clk) is

begin

	if clk'event and clk = '1' then

    	if clr = '1' then
        	
	dout <= 0;
        
	elsif wr='1' then

        	dout <=din;

        elsif wr='0' and ce='1' then

        	if dout=n-1 then

            	dout<=0;

            else

            	dout <= dout+1;

            end if;

        end if;

    end if;

end process;

end;

--testbench

-- Code your testbench here

library IEEE;

use IEEE.std_logic_1164.all;


entity tb is

generic(
n: integer := 12); -- osnova brojanja

end entity;


architecture tb of tb is

	signal clk,clr,ce,wr: bit;

    signal din: integer range 0 to 127;

    signal dout: integer range 0 to 127;

begin

uut: entity work.ctr(arch)

generic map(
	n => n)

port map(
	clk => clk,
    clr => clr,
    ce => ce,
    wr => wr,
    din => din,
    dout => dout);

clk_gen: process is

begin
	clk <= '1';
    wait for 10ns;

    clk <= '0';

    wait for 10ns;

end process clk_gen;


process is

begin
	clr<='1';

    wait for 20ns;

    clr<='0';

    wr<='1';

    ce<='1';

    din<=3;

    wait for 20ns;

    wr<='0';

    wait  for 240ns;
 -- x * tkatni ciklus gde broj x puta

    ce<='0';

    wait for 20ns;

	wait;

end process;

end;