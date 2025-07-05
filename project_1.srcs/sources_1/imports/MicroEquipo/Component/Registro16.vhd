library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Registro1 is
    Port (
        Reset        : in  STD_LOGIC;
        Carga        : in  STD_LOGIC;  
        Entradas     : in  STD_LOGIC_VECTOR(8 downto 0);
        Salida_total : out STD_LOGIC_VECTOR(8 downto 0)
    );
end Registro1;

architecture Behavioral of Registro1 is
    signal registro      : STD_LOGIC_VECTOR(8 downto 0) := (others => '0');
    signal carga_prev    : STD_LOGIC := '0';  
begin
    process(Carga, Reset)
    begin
        if Reset = '1' then
            registro <= (others => '0');
        elsif (carga_prev = '0' and Carga = '1') then
            registro <= Entradas;
        end if;
        carga_prev <= Carga;
    end process;

    Salida_total <= registro;
end Behavioral;
