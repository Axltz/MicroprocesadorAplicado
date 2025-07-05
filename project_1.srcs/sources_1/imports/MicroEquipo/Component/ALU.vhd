library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_4bits is
    Port (
        A                : in  STD_LOGIC_VECTOR(3 downto 0); 
        B                : in  STD_LOGIC_VECTOR(3 downto 0);  
        Operacion        : in  STD_LOGIC_VECTOR(2 downto 0);
        dispositivo_sel  : in  STD_LOGIC_VECTOR(1 downto 0);
        ENABLE           : in  STD_LOGIC;
        RESET            : in  STD_LOGIC;
        RESULT           : out STD_LOGIC_VECTOR(3 downto 0);
        salida_aspersor  : out STD_LOGIC;
        salida_clima     : out STD_LOGIC;
        salida_luz       : out STD_LOGIC
    );
end ALU_4bits;

architecture Behavioral of ALU_4bits is
    signal resultado : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
begin

    process(A, B, Operacion, dispositivo_sel, ENABLE, RESET)
    begin
        if RESET = '1' then
            resultado        <= (others => '0');
            salida_aspersor  <= '0';
            salida_clima     <= '0';
            salida_luz       <= '0';
        
        elsif ENABLE = '1' then
            salida_aspersor  <= '0';
            salida_clima     <= '0';
            salida_luz       <= '0';

            case Operacion is
                when "001" =>  -- READ_SENSOR: pasar A
                    resultado <= A;

                when "010" =>  -- STORE: pasar B
                    resultado <= B;

                when "011" =>  -- FILTER: ejemplo, A XOR B
                    resultado <= A xor B;

                when "100" =>  -- COMPARE: ejecutar decisión basada en sensor
                    resultado <= "0001"; -- Bandera de comparación exitosa (opcional)

                    case dispositivo_sel is
                        when "01" =>  -- Humedad: si A < 8, activar aspersor
                            if unsigned(A) < "1000" then
                                salida_aspersor <= '1';
                            end if;

                        when "10" =>  -- Luz: si A < 5, activar luz
                            if unsigned(A) < "0101" then
                                salida_luz <= '1';
                            end if;

                        when "11" =>  -- Temperatura: si A > 11 (33°C), activar clima
                            if unsigned(A) > "1011" then
                                salida_clima <= '1';
                            end if;

                        when others => null;
                    end case;

                when "101" =>  -- ACTIVATE (manual)
                    resultado <= "0001";

                when "110" =>  -- DEACTIVATE (manual)
                    resultado <= "0000";

                when "000" => --Nop
                     resultado <= (others => '0');

                when others =>
                    resultado <= (others => '0');
            end case;
        else
            resultado <= (others => '0');
        end if;
    end process;

    RESULT <= resultado;

end Behavioral;
