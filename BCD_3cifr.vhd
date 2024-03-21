library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
        
        
entity BCD_brojac is
port(
    clock : in bit;
    reset : in bit;
    CE : in bit;
    WR : in bit;
    Din : in unsigned(11 downto 0);
    Dout : out unsigned(11 downto 0)
    );
end entity;

architecture BCD_brojac_arch of BCD_brojac is
begin
    
    radi: process( clock, reset) is
            variable brojac : unsigned(11 downto 0);
            variable deo1 : unsigned(3 downto 0);
            variable deo2 : unsigned (3 downto 0);
            variable deo3 : unsigned(3 downto 0);
    begin
        
        if reset = '1' then
            brojac := "100110011001";
        
        elsif clock'event and clock='1' then
            
            if WR = '1' then 
                brojac := Din;
                
            elsif WR = '0' and CE = '1' then
                      deo1 := brojac(3) & brojac(2) & brojac(1) & brojac(0);
                    deo2 := brojac(7) & brojac(6) & brojac(5) & brojac(4);
                    deo3 := brojac(11) & brojac(10) & brojac(9) & brojac(8);
                    
                    if deo1 = "0000" then
                        deo1 := "1001";
                        if deo2 = "0000" then
                            deo2 := "1001";
                            deo3 := deo3 - 1;
                        else
                            deo2 := deo2 - 1;
                        end if;
                        
                    else
                        deo1 := deo1 - 1;
                    end if;
                    
                   brojac := deo3 & deo2 & deo1;           
            end if;
         end if;
       Dout <= brojac;
    end process radi;
end architecture;


--testbench

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BCD_brojac_tb is
end BCD_brojac_tb;

architecture sim of BCD_brojac_tb is
    -- Component Declaration for Unit Under Test (UUT)
    component BCD_brojac
        port(
            clock : in bit;
            reset : in bit;
            CE : in bit;
            WR : in bit;
            Din : in unsigned(11 downto 0);
            Dout : out unsigned(11 downto 0)
        );
    end component;

    -- Clock signal generation process
    constant clk_period : time := 10 ns;
    signal clock : bit := '0';
    signal reset : bit := '0';
    signal CE : bit := '0';
    signal WR : bit := '0';
    signal Din : unsigned(11 downto 0) := (others => '0');
    signal Dout : unsigned(11 downto 0);

begin
    -- Instantiate the Unit Under Test (UUT)
    UUT : BCD_brojac
        port map(
            clock => clock,
            reset => reset,
            CE => CE,
            WR => WR,
            Din => Din,
            Dout => Dout
        );

    -- Clock process definitions
    clk_process : process
    begin
        while now < 1000 ns loop
            clock <= '0';
            wait for clk_period / 2;
            clock <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;

        -- Write data
        Din <= "000100000001";
        CE <= '1';
        WR <= '1';
        wait for 10 ns;

        -- Disable write
        WR <= '0';
        wait for 20 ns;

        -- Enable write
        WR <= '1';
        wait for 10 ns;

        -- Reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;

        -- Write data
        Din <= "000000000011";
        CE <= '1';
        WR <= '1';
        wait for 10 ns;

        -- Disable write
        WR <= '0';
        wait for 10 ns;

        -- Enable write
        WR <= '1';
        wait for 10 ns;

        -- Stimulus ends
        wait;
    end process;

end sim;