library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
port (clk, rst, WR, CE: in bit;
		Din: in unsigned(3 downto 0);
        bcd_out: out unsigned(7 downto 0);
        cout: out bit);
end entity;

architecture behaviour of counter is
begin
	process(clk)
	variable d1: unsigned(3 downto 0):="0000";
	variable d2: unsigned(3 downto 0):="0000";
    variable D: unsigned(7 downto 0):="00000000";
    begin
    	if clk'event and clk='1' then 
         if rst='1' then
          d1:="0000";
          d2:="0000";
         elsif CE='1' then
          if WR='1' then
           d1:=Din;
          elsif (d1="1001" and d2="1001") then
           d1:="0000";
           d2:="0000";
          else
           if d1="1001" then 
            d1:="0000";
            if d2="1001" then
             d2:="0000";
            else d1:=d1+1;
            end if;
           else d2:=d2+1;
           end if;
          end if;
         end if;
        end if;
    D:=d2&d1;
    bcd_out<=D;
	end process;
end architecture;

--testbench

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter_tb is
end entity;

architecture sim of counter_tb is
    -- Signal declarations
    signal clk, rst, WR, CE: bit := '0';
    signal Din: unsigned(3 downto 0) := (others => '0');
    signal bcd_out: unsigned(7 downto 0);
    signal cout: bit;

    -- Component instantiation
    component counter
    port (
        clk, rst, WR, CE: in bit;
        Din: in unsigned(3 downto 0);
        bcd_out: out unsigned(7 downto 0);
        cout: out bit
    );
    end component;

begin
    UUT: entity work.counter(behaviour)
    port map (
        clk => clk,
        rst => rst,
        WR => WR,
        CE => CE,
        Din => Din,
        bcd_out => bcd_out,
        cout => cout
    );

    -- Clock process
    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        rst <= '1';  -- Reset active high
        WR <= '0';   -- Write disable
        CE <= '0';   -- Count disable
        Din <= (others => '0');  -- Input data
        wait for 10 ns;
        
        rst <= '0';  -- Deassert reset
        wait for 10 ns;

        CE <= '1';   -- Enable counting
        wait for 20 ns;

        CE <= '0';   -- Disable counting
        wait for 10 ns;

        CE <= '1';   -- Enable counting
        wait for 40 ns;

        -- Add more test cases as needed...

        wait;
    end process;

end architecture;
