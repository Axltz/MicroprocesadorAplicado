library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decodificador is
    Port (
        instruccion : in  STD_LOGIC_VECTOR(8 downto 0);  
        dispositivo: out STD_LOGIC_VECTOR(1 downto 0); 
        operacion   : out STD_LOGIC_VECTOR(2 downto 0)  

    );
end decodificador;

architecture Behavioral of decodificador is
begin
    process(instruccion)
    begin
        dispositivo <= instruccion(8 downto 7);
        operacion <= instruccion(6 downto 4);
    end process;
end Behavioral;
