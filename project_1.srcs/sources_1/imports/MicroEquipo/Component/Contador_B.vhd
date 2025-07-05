library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ContadorB is
    Port (
        CLK     : in  STD_LOGIC;
        Reset   : in  STD_LOGIC;
        Salidas : out STD_LOGIC_VECTOR(1 downto 0)
    );
end ContadorB;

architecture Behavioral of ContadorB is
    signal contador : unsigned(1 downto 0) := (others => '0');
begin
    process(CLK, Reset)
    begin
        if Reset = '1' then
            contador <= (others => '0');
        elsif rising_edge(CLK) then
            contador <= contador + 1;
        end if;
    end process;

    Salidas <= std_logic_vector(contador);

end Behavioral;
