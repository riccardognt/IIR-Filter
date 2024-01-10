LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

ENTITY myIIR2 IS
	 
	PORT ( b0,b1,b2,a1,a2 : in std_logic_vector(13 downto 0);
			 DIN : in std_logic_vector(13 downto 0);
		    VIN, CLK : in std_logic;
			 RST_n : in std_logic;
			 DOUT : out std_logic_vector (13 downto 0);
			 VOUT : out std_logic); -- control singnals
			 
END myIIR2;

ARCHITECTURE Structure OF myIIR2 IS

signal sig_DIN : std_logic_vector(13 downto 0);
signal VIN_reg : std_logic;
signal sig0, sig1, sig2, siga1, siga2, sigb0, sigb1, sigb2, sig4, sig10 : std_logic_vector(13 downto 0);
signal sig3_trunc_7, sig5_trunc_7, sig6_trunc_7, sig7_trunc_7, sig9_trunc_7 : std_logic_vector(6 downto 0);
signal sig0_trunc_8, sig8_trunc_8, sig9_trunc_8  : std_logic_vector(7 downto 0); 
signal sig10_trunc_9 : std_logic_vector(8 downto 0);

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
	REG port map (CLK=>CLK, RST=>RST_n, ENABLE =>VIN, D=>DIN, Q=>sig_DIN);
	
REG_out:
	REG port map (CLK=>CLK, RST=>RST_n, ENABLE =>VIN_reg, D=>sig10, Q=>DOUT);
	
FF_in:
	FF port map (CLK=>CLK, RST=>RST_n, D=>VIN, Q=>VIN_reg );
	
FF_out:
	FF port map (CLK=>CLK, RST=>RST_n, D=>VIN_reg, Q=>VOUT );

SUB1:
	SUBTRACT generic map (Nbit=> 14)
				port map (a=> sig_DIN, b=>sig0, result=>sig1);
		
SUM1:
	ADD generic map (Nbit=> 7)
		port map (a=> sig5_trunc_7, b=>sig3_trunc_7, sum=>sig0_trunc_8);

sig0<=sig0_trunc_8 & "000000";
sig9_trunc_8 <= sig9_trunc_7 & "0";
	
SUM2:
	ADD generic map (Nbit=> 8)
		port map (a=> sig9_trunc_8, b=>sig8_trunc_8, sum=>sig10_trunc_9);

sig10 <= sig10_trunc_9 & "00000";
	
SUM3:
	ADD generic map (Nbit=> 7)
		port map (a=> sig7_trunc_7, b=>sig6_trunc_7, sum=>sig8_trunc_8);

REGX:
	REG port map (CLK=>CLK, RST=>RST_n, ENABLE =>VIN, D=>sig1, Q=>sig2);
	
REGY:
	REG port map (CLK=>CLK, RST=>RST_n, ENABLE =>VIN, D=>sig2, Q=>sig4);
	
MULT1:
	MULT generic map (SHAMT=> 20)
	port map (am=>sig2 ,bm=>siga1 ,mult =>sig3_trunc_7);
	
MULT2:
	MULT generic map (SHAMT=> 20)
	port map (am=>sig4 ,bm=>siga2 ,mult =>sig5_trunc_7);
	
MULT3:
	MULT generic map (SHAMT=> 20)
	port map (am=>sig1 ,bm=>sigb0 ,mult=>sig9_trunc_7);


	
MULT4:
	MULT generic map (SHAMT=> 20)
	port map (am=>sig2 ,bm=>sigb1 ,mult =>sig7_trunc_7);
	
MULT5:
	MULT generic map (SHAMT=> 20)
	port map (am=>sig4 ,bm=>sigb2 ,mult =>sig6_trunc_7);
	
REG0:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>a1, Q=>siga1);
	
REG1:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>a2, Q=>siga2);
	
REG2:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>b0, Q=>sigb0);
	
REG3:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>b1, Q=>sigb1);
	
REG4:
	REGNOEN port map (CLK=>CLK, RST=>RST_n, D=>b2, Q=>sigb2);



END Structure;
