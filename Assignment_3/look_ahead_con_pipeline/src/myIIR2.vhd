LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

ENTITY myIIR2 IS
	 
	PORT (  b0, b1, b2, b3, a2, a3 : in std_logic_vector(13 downto 0);
			DIN : in std_logic_vector(13 downto 0);
		    VIN, CLK : in std_logic;
			RST_n : in std_logic;
			DOUT : out std_logic_vector (13 downto 0);
			VOUT : out std_logic); -- control singnals
			 
END myIIR2;

ARCHITECTURE Structure OF myIIR2 IS

signal VIN_reg1, VIN_reg2 : std_logic;
signal sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8 : std_logic_vector(13 downto 0);
signal sig9, sig10, sig11, sig12, sig13, sig14, sig15, sig16, sig17, sig18 : std_logic_vector(13 downto 0);
signal sigb0, sigb1, sigb2, sigb3, siga2, siga3 : std_logic_vector(13 downto 0);

signal sig5_trunc7, sig4_trunc7, sig6_trunc7, sig9_trunc7, sig10_trunc7, sig11_trunc7, sig14_trunc7, sig17_trunc7 : std_logic_vector(6 downto 0);
signal sig7_trunc8, sig13_trunc8, sig14_trunc8, sig12_trunc8 : std_logic_vector(7 downto 0);
signal sig15_trunc9, sig16_trunc9, sig17_trunc9 : std_logic_vector(8 downto 0);
signal sig18_trunc10 : std_logic_vector(9 downto 0);


COMPONENT FF IS
	PORT (  CLK     :   in std_logic;                       
        	RST     :   in std_logic;                                        
        	D       :   in std_logic;
		  	Q       :   out std_logic); -- control singnals
END COMPONENT;

COMPONENT REG IS
	port (
			CLK     :   in std_logic;                       
        	RST     :   in std_logic;                       
        	ENABLE  :   in  std_logic;                  
        	D       :   in std_logic_vector(13 downto 0);
		  	Q       :   out std_logic_vector(13 downto 0)
		);
END COMPONENT;

COMPONENT REGNOEN IS
	port (
			CLK     :   in std_logic;                       
        	RST     :   in std_logic;                                         
        	D       :   in std_logic_vector(13 downto 0);
		  	Q       :   out std_logic_vector(13 downto 0)
		);
END COMPONENT;

COMPONENT MULT IS
	generic (
		SHAMT : positive := 20
		);
    Port (
        am : in  STD_LOGIC_VECTOR(13 downto 0);
        bm : in  STD_LOGIC_VECTOR(13 downto 0);
        --sel: in STD_LOGIC;
        mult : out  STD_LOGIC_VECTOR(6 downto 0)
        );
END COMPONENT;

COMPONENT ADD IS
	generic( Nbit: integer := 14);
    Port (
        a : in  STD_LOGIC_VECTOR(Nbit-1 downto 0); --inputs in 14 bits, datas are already in signed format
        b : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
        sum : out  STD_LOGIC_VECTOR(Nbit downto 0)
        );
END COMPONENT;

COMPONENT SUBTRACT IS
    generic( Nbit: integer := 14);
    Port (
        a : in  STD_LOGIC_VECTOR(Nbit-1 downto 0); --inputs in 14 bits, datas are already in signed format
        b : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
        result : out  STD_LOGIC_VECTOR(Nbit-1 downto 0)
        );
END COMPONENT;

BEGIN

REG_in:
	REG port map (CLK=>CLK, RST=>RST_n, ENABLE =>VIN, D=>DIN, Q=>sig1);
	
REG_out:
	REG port map (CLK=>CLK, RST=>RST_n , ENABLE =>VIN_reg2, D=>sig18, Q=>DOUT);

sig18 <= sig18_trunc10 & "0000";
	
FF1:
	FF port map (CLK=>CLK, RST=>RST_n, D=>VIN, Q=>VIN_reg1);
	
FF2:
	FF port map (CLK=>CLK, RST=>RST_n, D=>VIN_reg1, Q=>VIN_reg2);

FF3:
	FF port map (CLK=>CLK, RST=>RST_n, D=>VIN_reg2, Q=>VOUT);
	
SUM1:
	ADD generic map (Nbit => 7)
	port map (a=> sig4_trunc7, b=>sig6_trunc7, sum=>sig7_trunc8);

sig6_trunc7 <= sig6(13 downto 7);
		
SUM2:
	ADD generic map (Nbit => 7)
	port map (a=> sig10_trunc7, b=>sig11_trunc7, sum=>sig12_trunc8);

sig10_trunc7 <= sig10(13 downto 7);
	
SUM3:
	ADD generic map (Nbit => 8)
	port map (a=> sig13_trunc8, b=>sig14_trunc8, sum=>sig15_trunc9);

sig13_trunc8 <= sig13(13 downto 6);
sig14_trunc8 <= sig14_trunc7 & "0";
	
SUM4:
	ADD generic map (Nbit => 9)
	port map (a=> sig16_trunc9, b=>sig17_trunc9, sum=>sig18_trunc10);

sig17_trunc9 <= sig17_trunc7 & "00";
sig16_trunc9 <= sig16(13 downto 5);

SUB1:
	SUBTRACT generic map (Nbit => 14)
	port map (a=> sig1, b=>sig8, result=>sig2);
	
MULT1:
	MULT generic map (SHAMT=> 20)
	port map (am=>siga2, bm=>sig3, mult =>sig4_trunc7);
	
MULT2:
	MULT generic map (SHAMT=> 20)
	port map (am=>siga3, bm=>sig3, mult =>sig5_trunc7);
	
MULT3:
	MULT generic map (SHAMT=> 20)
	port map (am=>sigb3, bm=>sig3, mult =>sig9_trunc7);
	
MULT4:
	MULT generic map (SHAMT=> 20)
	port map (am=>sigb2, bm=>sig3, mult =>sig11_trunc7);
	
MULT5:
	MULT generic map (SHAMT=> 20)
	port map (am=>sigb1, bm=>sig3, mult =>sig14_trunc7);

MULT6:
	MULT generic map (SHAMT=> 20)
	port map (am=>sigb0, bm=>sig3, mult =>sig17_trunc7);

REG_pipe:
	REG port map (CLK=>CLK, RST=>RST_n,ENABLE =>VIN_reg1, D=>sig2, Q=>sig3);
	
REG0:
	REG port map (CLK=>CLK, RST=>RST_n,ENABLE =>VIN_reg1, D=>sig7, Q=>sig8);

sig7 <= sig7_trunc8 & "000000";
	
REG1:
	REG port map (CLK=>CLK, RST=>RST_n,ENABLE =>VIN_reg1, D=>sig5, Q=>sig6);

sig5 <= sig5_trunc7 & "0000000";
	
REG2:
	REG port map (CLK=>CLK, RST=>RST_n,ENABLE =>VIN_reg1, D=>sig9, Q=>sig10);

sig9 <= sig9_trunc7 & "0000000";

REG3:
	REG port map (CLK=>CLK, RST=>RST_n,ENABLE =>VIN_reg1, D=>sig12, Q=>sig13);

sig12 <= sig12_trunc8 & "000000";

REG4:
	REG port map (CLK=>CLK, RST=>RST_n,ENABLE =>VIN_reg1, D=>sig15, Q=>sig16);

sig15 <= sig15_trunc9 & "00000";

--Registers for the coefficients         
REGb0:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>b0, Q=>sigb0);

REGb1:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>b1, Q=>sigb1);

REGb2:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>b2, Q=>sigb2);

REGb3:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>b3, Q=>sigb3);

REGa2:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>a2, Q=>siga2);

REGa3:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>a3, Q=>siga3);

END Structure;
