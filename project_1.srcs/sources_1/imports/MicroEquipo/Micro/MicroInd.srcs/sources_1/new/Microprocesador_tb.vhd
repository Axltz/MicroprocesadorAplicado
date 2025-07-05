library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Microprocesador is
end tb_Microprocesador;

architecture Behavioral of tb_Microprocesador is

    signal clk           : std_logic := '0';
    signal reset         : std_logic := '0';
    signal set_pc        : std_logic := '0';

    signal sensor_Humedad     : std_logic_vector(3 downto 0) := (others => '0');
    signal sensor_Luz         : std_logic_vector(3 downto 0) := (others => '0');
    signal sensor_Temperatura : std_logic_vector(3 downto 0) := (others => '0');

    signal pc_fin      : std_logic_vector(4 downto 0);
    signal Ciclo       : std_logic_vector(1 downto 0);
    signal instr       : std_logic_vector(2 downto 0);
    signal mar_out     : std_logic_vector(4 downto 0);
    signal Gpr_out     : std_logic_vector(8 downto 0);
    signal alu_result  : std_logic_vector(3 downto 0);
    signal buss        : std_logic_vector(8 downto 0);

    -- Señales internas adicionales
    signal pc_out_internal         : std_logic_vector(4 downto 0);
    signal mar_out_internal        : std_logic_vector(4 downto 0);
    signal rom_out_internal        : std_logic_vector(8 downto 0);
    signal opc_internal            : std_logic_vector(2 downto 0);
    signal registro_total_internal : std_logic_vector(8 downto 0);
    signal alu_res_internal        : std_logic_vector(3 downto 0);
    signal ciclo_pulsos_internal   : std_logic_vector(1 downto 0);
    signal en_pc_internal          : std_logic;
    signal en_mar_internal         : std_logic;
    signal en_gpr_internal         : std_logic;
    signal en_alu_internal         : std_logic;
    signal acumulador_out_debug    : std_logic_vector(3 downto 0);

    signal salida_aspersor : std_logic;
    signal salida_luz      : std_logic;
    signal salida_clima    : std_logic;

    constant clk_period : time := 10 ns;

begin

    -- Instancia del microprocesador
    UUT: entity work.Microprocesador
        port map (
            clk         => clk,
            reset       => reset,
            set_pc      => set_pc,
            sensor_Humedad     => sensor_Humedad,
            sensor_Luz         => sensor_Luz,
            sensor_Temperatura => sensor_Temperatura,

            pc_fin      => pc_fin,
            Ciclo       => Ciclo,
            instr       => instr,
            mar_out     => mar_out,
            Gpr_out     => Gpr_out,
            alu_result  => alu_result,
            buss        => buss,

            pc_out_internal         => pc_out_internal,
            mar_out_internal        => mar_out_internal,
            rom_out_internal        => rom_out_internal,
            opc_internal            => opc_internal,
            registro_total_internal => registro_total_internal,
            alu_res_internal        => alu_res_internal,
            ciclo_pulsos_internal   => ciclo_pulsos_internal,
            en_pc_internal          => en_pc_internal,
            en_mar_internal         => en_mar_internal,
            en_gpr_internal         => en_gpr_internal,
            en_alu_internal         => en_alu_internal,
            acumulador_out_debug    => acumulador_out_debug,

            salida_aspersor => salida_aspersor,
            salida_luz      => salida_luz,
            salida_clima    => salida_clima
        );

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

stim_proc: process
begin
    -- Primer reinicio y estímulo
    reset <= '1';
    wait for 20 ns;
    reset <= '0';

    -- CASO 1: Activar aspersor, luz y clima
    sensor_Humedad     <= "0011";  -- 3 < 8 ? activa aspersor
    sensor_Luz         <= "0100";  -- 4 < 5 ? activa luz
    sensor_Temperatura <= "1110";  -- 14 > 11 ? activa clima

    set_pc <= '1';
    wait for clk_period;
    set_pc <= '0';

    -- Esperar a que pc_fin llegue a 23 (10111 en binario)
    wait until pc_fin = "10111";

    -- CASO 2: Solo activar clima (humedad y luz no cumplen)
    reset <= '1'; -- reinicio suave para siguiente caso
    wait for 20 ns;
    reset <= '0';

    sensor_Humedad     <= "1001";  -- 9 ? 8 ? no aspersor
    sensor_Luz         <= "0110";  -- 6 ? 5 ? no luz
    sensor_Temperatura <= "1100";  -- 12 > 11 ? sí clima

    set_pc <= '1';
    wait for clk_period;
    set_pc <= '0';

    -- Esperar hasta el final del segundo ciclo (opcionalmente otro pc_fin = 23)
    wait until pc_fin = "10111";

    wait;
end process;


end Behavioral;
