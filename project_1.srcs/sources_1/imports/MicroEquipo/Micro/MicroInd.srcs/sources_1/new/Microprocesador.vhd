library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Microprocesador is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        set_pc      : in  STD_LOGIC;

        sensor_Humedad     : in  STD_LOGIC_VECTOR(3 downto 0);
        sensor_Luz         : in  STD_LOGIC_VECTOR(3 downto 0);
        sensor_Temperatura : in  STD_LOGIC_VECTOR(3 downto 0);

        pc_fin      : out STD_LOGIC_VECTOR(4 downto 0);
        Ciclo       : out STD_LOGIC_VECTOR(1 downto 0);
        instr       : out STD_LOGIC_VECTOR(2 downto 0);
        mar_out     : out STD_LOGIC_VECTOR(4 downto 0);
        Gpr_out     : out STD_LOGIC_VECTOR(8 downto 0);
        alu_result  : out STD_LOGIC_VECTOR(3 downto 0);
        buss        : out STD_LOGIC_VECTOR(8 downto 0);

        pc_out_internal         : out STD_LOGIC_VECTOR(4 downto 0);
        mar_out_internal        : out STD_LOGIC_VECTOR(4 downto 0);
        rom_out_internal        : out STD_LOGIC_VECTOR(8 downto 0);
        opc_internal            : out STD_LOGIC_VECTOR(2 downto 0);
        registro_total_internal : out STD_LOGIC_VECTOR(8 downto 0);
        alu_res_internal        : out STD_LOGIC_VECTOR(3 downto 0);
        ciclo_pulsos_internal   : out STD_LOGIC_VECTOR(1 downto 0);
        en_pc_internal          : out STD_LOGIC;
        en_mar_internal         : out STD_LOGIC;
        en_gpr_internal         : out STD_LOGIC;
        en_alu_internal         : out STD_LOGIC;
        acumulador_out_debug : out STD_LOGIC_VECTOR(3 downto 0);


        salida_aspersor : out STD_LOGIC;
        salida_clima    : out STD_LOGIC;
        salida_luz      : out STD_LOGIC
    );
end Microprocesador;

architecture Behavioral of Microprocesador is

    -- Señales internas
    signal pc_out         : STD_LOGIC_VECTOR(4 downto 0);
    signal mar_out2       : STD_LOGIC_VECTOR(4 downto 0);
    signal rom_out        : STD_LOGIC_VECTOR(8 downto 0);
    signal opc            : STD_LOGIC_VECTOR(2 downto 0);
    signal dispositivo_sel: STD_LOGIC_VECTOR(1 downto 0);
    signal dato_A, dato_B : STD_LOGIC_VECTOR(3 downto 0);

    signal registro_total : STD_LOGIC_VECTOR(8 downto 0);
    signal alu_res        : STD_LOGIC_VECTOR(3 downto 0);
    signal acumulador_out : STD_LOGIC_VECTOR(3 downto 0);

    signal ciclo_pulsos   : STD_LOGIC_VECTOR(1 downto 0);

    signal en_pc, en_mar, en_gpr, en_alu : STD_LOGIC;

    signal salida_aspersor_sig : STD_LOGIC := '0';
    signal salida_clima_sig    : STD_LOGIC := '0';
    signal salida_luz_sig      : STD_LOGIC := '0';

begin

    -- Secuenciador para el ciclo de reloj
    SECUENCIADOR: entity work.ContadorB
        port map (
            CLK     => clk,
            Reset   => reset,
            Salidas => ciclo_pulsos
        );

    -- Control de habilitación según ciclo
    process(clk, reset)
    begin
        if reset = '1' then
            en_pc  <= '0';
            en_mar <= '0';
            en_gpr <= '0';
            en_alu <= '0';
        elsif rising_edge(clk) then
            case ciclo_pulsos is
                when "00" => 
                    en_pc  <= '1';
                    en_mar <= '0';
                    en_gpr <= '0';
                    en_alu <= '0';
                when "01" => 
                    en_pc  <= '0';
                    en_mar <= '1';
                    en_gpr <= '0';
                    en_alu <= '0';
                when "10" => 
                    en_pc  <= '0';
                    en_mar <= '0';
                    en_gpr <= '1';
                    en_alu <= '0';
                when "11" => 
                    en_pc  <= '0';
                    en_mar <= '0';
                    en_gpr <= '0';
                    en_alu <= '1';
                when others => 
                    en_pc  <= '0';
                    en_mar <= '0';
                    en_gpr <= '0';
                    en_alu <= '0';
            end case;
        end if;
    end process;

    Ciclo <= ciclo_pulsos;

    -- Contador PC
    PC: entity work.Contador
        port map (
            Enable   => en_pc,
            Reset    => reset,
            Set      => set_pc,
            Entradas => (others => '0'),
            Salidas  => pc_out
        );

    -- Registro MAR
    MAR: entity work.Registro8
        port map (
            enable    => en_mar,
            Reset     => reset,
            Entradas  => pc_out,
            Salidas   => mar_out2
        );

    -- Memoria ROM
    ROM: entity work.memoria_ROM
        port map (
            direccion => mar_out2,
            dato      => rom_out
        );

    -- Registro GPR
    GPR: entity work.Registro1
        port map (
            Carga        => en_gpr,
            Reset        => reset,
            Entradas     => rom_out,
            Salida_total => registro_total
        );

    -- Decodificador de instrucciones
    Decodificador: entity work.decodificador
        port map (
            instruccion => registro_total,
            dispositivo => dispositivo_sel,
            operacion   => opc
        );
    ACUMULADOR: entity work.Acumulador
        port map (
         enable    => en_alu,
         reset     => reset,
         data_in   => alu_res,
         data_out  => acumulador_out
        );

    -- Selección de dato A según dispositivo seleccionado
        process(dispositivo_sel, sensor_Humedad, sensor_Luz, sensor_Temperatura, ciclo_pulsos, acumulador_out)
        begin
            if ciclo_pulsos = "11" then  -- Cuando se ejecuta una operación
                dato_A <= acumulador_out;
            else
                case dispositivo_sel is
                    when "01" => dato_A <= sensor_Humedad;
                    when "10" => dato_A <= sensor_Luz;
                    when "11" => dato_A <= sensor_Temperatura;
                    when others => dato_A <= (others => '0');
                end case;
            end if;
        end process;
        
    dato_B <= registro_total(3 downto 0);

    -- ALU 4 bits
    ALU: entity work.ALU_4bits
        port map (
            A                => dato_A,
            B                => dato_B,
            Operacion        => opc,
            dispositivo_sel  => dispositivo_sel,
            ENABLE           => en_alu,
            RESET            => reset,
            RESULT           => alu_res,
            salida_aspersor  => salida_aspersor_sig,
            salida_clima     => salida_clima_sig,
            salida_luz       => salida_luz_sig
        );

    pc_fin     <= pc_out;
    mar_out    <= mar_out2;
    Gpr_out    <= registro_total;
    instr      <= opc;
    alu_result <= alu_res;
    buss       <= rom_out;

    pc_out_internal         <= pc_out;
    mar_out_internal        <= mar_out2;
    rom_out_internal        <= rom_out;
    
    opc_internal            <= opc;
    registro_total_internal <= registro_total;

    alu_res_internal        <= alu_res;    
    acumulador_out_debug <= acumulador_out;
    ciclo_pulsos_internal   <= ciclo_pulsos;
    en_pc_internal          <= en_pc;
    en_mar_internal         <= en_mar;
    en_gpr_internal         <= en_gpr;
    en_alu_internal         <= en_alu;


    salida_aspersor <= salida_aspersor_sig;
    salida_clima    <= salida_clima_sig;
    salida_luz      <= salida_luz_sig;

end Behavioral;
