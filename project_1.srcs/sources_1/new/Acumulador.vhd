library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Acumulador is
    Port (
        enable   : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        data_in  : in  STD_LOGIC_VECTOR(3 downto 0);
        data_out : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Acumulador;

architecture Behavioral of Acumulador is
    signal reg : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
begin
    process(enable, reset, data_in)
    begin
        if reset = '1' then
            reg <= (others => '0');
        elsif enable = '1' then
            reg <= data_in;
        end if;
    end process;

    data_out <= reg;
end Behavioral;
