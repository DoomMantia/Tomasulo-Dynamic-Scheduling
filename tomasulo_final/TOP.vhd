library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is Port (
    IssueIn             : in STD_LOGIC;
    FUType              : in STD_LOGIC_VECTOR (1 downto 0);
    Fop                 : in STD_LOGIC_VECTOR (1 downto 0);
    Ri                  : in STD_LOGIC_VECTOR (4 downto 0);
    Rj                  : in STD_LOGIC_VECTOR (4 downto 0);
    Rk                  : in STD_LOGIC_VECTOR (4 downto 0);
    BufferAvailable     : in STD_LOGIC_VECTOR (2 downto 0);
    CDB_QBuffer         : in STD_LOGIC_VECTOR (4 downto 0);
    CDB_VBuffer         : in STD_LOGIC_VECTOR (31 downto 0);
    CDB_BufferRequest   : in STD_LOGIC;
    PCIn                : in STD_LOGIC_VECTOR(31 downto 0);
    ExceptionIn         : in std_logic;
    Clk                 : in STD_LOGIC;
    Rst                 : in STD_LOGIC;
    Accepted            : out STD_LOGIC;
    InstrTypeOut        : out STD_LOGIC_VECTOR(1 downto 0);
    PCOut               : out STD_LOGIC_VECTOR(31 downto 0);
    Exception           : out STD_LOGIC);
end TOP;

architecture Behavioral of TOP is
    component IssueUnit Port(
        IssueIn 			      : in STD_LOGIC;
        FUType 				      : in STD_LOGIC_VECTOR (1 downto 0);
        Fop 				        : in STD_LOGIC_VECTOR (1 downto 0);
        Ri 					        : in STD_LOGIC_VECTOR (4 downto 0);
        Rj 					        : in STD_LOGIC_VECTOR (4 downto 0);
        Rk 					        : in STD_LOGIC_VECTOR (4 downto 0);
        RFReadAddr1 		    : out STD_LOGIC_VECTOR (4 downto 0);
        RFReadAddr2 		    : out STD_LOGIC_VECTOR (4 downto 0);
        RFTag 				      : out STD_LOGIC_VECTOR (4 downto 0);
        RFAddrW 			      : out STD_LOGIC_VECTOR (4 downto 0);
        RFWrEn 				      : out STD_LOGIC;
        Accepted 			      : out STD_LOGIC;
        OpOut 				      : out STD_LOGIC_VECTOR (1 downto 0);
        ArithmeticAvailable : in STD_LOGIC_VECTOR (2 downto 0);
        ArithmeticIssue 	  : out STD_LOGIC;
        LogicalAvailable 	  : in STD_LOGIC_VECTOR (2 downto 0);
        LogicalIssue 		    : out STD_LOGIC;
        BufferAvailable 	  : in STD_LOGIC_VECTOR (2 downto 0);
        BufferIssue 		    : out STD_LOGIC;
        RoBFull             : in STD_LOGIC;
        Clk 				        : in STD_LOGIC;
        Rst 				        : in STD_LOGIC);   
    end component;

    component Arithmetic Port (
        RST 		   : in STD_LOGIC;
        CLK 		   : in STD_LOGIC;
        Issue 		 : in STD_LOGIC;
        Op 			   : in STD_LOGIC_VECTOR (1 downto 0);
        Vj 			   : in STD_LOGIC_VECTOR (31 downto 0);
        Vk 			   : in STD_LOGIC_VECTOR (31 downto 0);
        Qj 			   : in STD_LOGIC_VECTOR (4 downto 0);
        Qk 			   : in STD_LOGIC_VECTOR (4 downto 0);
        CDBV 		   : in STD_LOGIC_VECTOR (31 downto 0);
        CDBQ 		   : in STD_LOGIC_VECTOR (4 downto 0);
        Grant 		 : in STD_LOGIC;
        Available  : out STD_LOGIC_VECTOR(2 downto 0);
        VOut 		   : out STD_LOGIC_VECTOR (31 downto 0);
        QOut 		   : out STD_LOGIC_VECTOR (4 downto 0);
        RequestOut : out STD_LOGIC);
    end component;

    component Logical Port (
        RST 		: in STD_LOGIC;
        CLK         : in STD_LOGIC;
        Issue 		: in STD_LOGIC;
        Op 			: in STD_LOGIC_VECTOR (1 downto 0);
        Vj 			: in STD_LOGIC_VECTOR (31 downto 0);
        Vk 			: in STD_LOGIC_VECTOR (31 downto 0);
        Qj 			: in STD_LOGIC_VECTOR (4 downto 0);
        Qk 			: in STD_LOGIC_VECTOR (4 downto 0);
        CDBV 		: in STD_LOGIC_VECTOR (31 downto 0);
        CDBQ 		: in STD_LOGIC_VECTOR (4 downto 0);
        Grant 		: in STD_LOGIC;
        Available 	: out STD_LOGIC_VECTOR(2 downto 0);
        VOut 		: out STD_LOGIC_VECTOR (31 downto 0);
        QOut 		: out STD_LOGIC_VECTOR (4 downto 0);
        RequestOut 	: out STD_LOGIC);
    end component;

    component RegisterFile Port (
        ReadAddr1 	: in STD_LOGIC_VECTOR (4 downto 0);
        ReadAddr2 	: in STD_LOGIC_VECTOR (4 downto 0);
        AddrW 		: in STD_LOGIC_VECTOR (4 downto 0);
        RFWrData    : in STD_LOGIC_VECTOR (31 downto 0);
        WrEn 		: in STD_LOGIC;
        Clk 		: in STD_LOGIC;
        Rst 		: in STD_LOGIC;
        DataOut1 	: out STD_LOGIC_VECTOR (31 downto 0);
        DataOut2 	: out STD_LOGIC_VECTOR (31 downto 0));
    end component;

    component CDB Port (
        QArithmetic 		: in STD_LOGIC_VECTOR (4 downto 0);
        VArithmetic 		: in STD_LOGIC_VECTOR (31 downto 0);
        QLogical 			: in STD_LOGIC_VECTOR (4 downto 0);
        VLogical 			: in STD_LOGIC_VECTOR (31 downto 0);
        QBuffer 			: in STD_LOGIC_VECTOR (4 downto 0);
        VBuffer 			: in STD_LOGIC_VECTOR (31 downto 0);
        ArithmeticRequest 	: in STD_LOGIC;
        LogicalRequest 		: in STD_LOGIC;
        BufferRequest 		: in STD_LOGIC;
        Clk 				: in STD_LOGIC;
        Rst 				: in STD_LOGIC;
        Qout 				: out STD_LOGIC_VECTOR (4 downto 0);
        Vout 				: out STD_LOGIC_VECTOR (31 downto 0);
        GrantArithmetic		: out STD_LOGIC;
        GrantLogical		: out STD_LOGIC;
        GrantBuffer			: out STD_LOGIC);
    end component;

    component ReorderBuffer Port (
        InstrTypeIn     : in std_logic_vector(1 downto 0);
        DestinationIn   : in std_logic_vector(4 downto 0);
        TagIn           : in std_logic_vector(4 downto 0);
        PCIn            : in std_logic_vector(31 downto 0);
        ExceptionIn     : in std_logic;
        CDBQ            : in std_logic_vector(4 downto 0);
        CDBV            : in std_logic_vector(31 downto 0);		
        WrEn            : in std_logic;
        ReadAddr1       : in std_logic_vector(4 downto 0);
        ReadAddr2       : in std_logic_vector(4 downto 0);
        Clk             : in std_logic;
        Rst             : in std_logic;
        RFAddr          : out std_logic_vector(4 downto 0);
        RFWrData        : out std_logic_vector(31 downto 0);
        RFWrEn          : out std_logic;
        Exc             : out std_logic;
        InstrTypeOut    : out std_logic_vector(1 downto 0);
        PCOut           : out std_logic_vector(31 downto 0);
        FullOut         : out std_logic;
        DataOut1        : out STD_LOGIC_VECTOR (31 downto 0);
        TagOut1         : out STD_LOGIC_VECTOR (4 downto 0);
        Available1      : out std_logic;
        DataOut2        : out STD_LOGIC_VECTOR (31 downto 0);
        TagOut2         : out STD_LOGIC_VECTOR (4 downto 0);
        Available2      : out std_logic);
    end component;
    -- Signals Of Component Outputs ---------------------------------------

    -- IssueUnit Signals :
    SIGNAL IssueUnit_RFReadAddr1		:STD_LOGIC_VECTOR (4 downto 0);
    SIGNAL IssueUnit_RFReadAddr2		:STD_LOGIC_VECTOR (4 downto 0);
    SIGNAL IssueUnit_RFTag				:STD_LOGIC_VECTOR (4 downto 0);
    SIGNAL IssueUnit_RFAddrW			:STD_LOGIC_VECTOR (4 downto 0);
    SIGNAL IssueUnit_RFWrEn				:STD_LOGIC;
    SIGNAL IssueUnit_Accepted			:STD_LOGIC;
    SIGNAL IssueUnit_OpOut 				:STD_LOGIC_VECTOR (1 downto 0);
    SIGNAL IssueUnit_ArithmeticIssue 	:STD_LOGIC;
    SIGNAL IssueUnit_LogicalIssue 		:STD_LOGIC;
    SIGNAL IssueUnit_BufferIssue 		:STD_LOGIC;

    --Arithmetic Signals
    SIGNAL Arithmetic_Available 		:STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL Arithmetic_VOut 				:STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL Arithmetic_QOut 				:STD_LOGIC_VECTOR (4 downto 0);
    SIGNAL Arithmetic_RequestOut 		:STD_LOGIC;

    --Logical Signals
    SIGNAL Logical_Available 			:STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL Logical_VOut 				:STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL Logical_QOut 				:STD_LOGIC_VECTOR (4 downto 0);
    SIGNAL Logical_RequestOut 			:STD_LOGIC;

    --Register File Signals
    SIGNAL RF_DataOut1 					:STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL RF_TagOut1					:STD_LOGIC_VECTOR (4 downto 0);
    SIGNAL RF_DataOut2 					:STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL RF_TagOut2					:STD_LOGIC_VECTOR (4 downto 0);

    --CDB Signals
    SIGNAL CDB_Qout 					:STD_LOGIC_VECTOR (4 downto 0);
    SIGNAL CDB_Vout 					:STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL CDB_GrantArithmetic			:STD_LOGIC;
    SIGNAL CDB_GrantLogical				:STD_LOGIC;
    SIGNAL CDB_GrantBuffer				:STD_LOGIC;

    --ReorderBuffer Signals
    SIGNAL ROB_RFWrEn                   :STD_LOGIC;
    SIGNAL ROB_RFAddr                   :STD_LOGIC_VECTOR (4 downto 0);
    SIGNAL ROB_RFWrData                 :STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL ROB_FullOut                  :STD_LOGIC;
    SIGNAL ROB_DataOut1                 :STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL ROB_TagOut1                  :STD_LOGIC_VECTOR (4 downto 0);
    SIGNAL ROB_Available1               :STD_LOGIC;
    SIGNAL ROB_DataOut2                 :STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL ROB_TagOut2                  :STD_LOGIC_VECTOR (4 downto 0);
    SIGNAL ROB_Available2               :STD_LOGIC;

    --Value & Tag Signals for Arithmetic & Logical
    SIGNAL VjSignal                     :STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL QjSignal                     :STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL VkSignal                     :STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL QkSignal                     :STD_LOGIC_VECTOR(4 downto 0);

    -- Temps
    SIGNAL Buffer_Available 			:STD_LOGIC_VECTOR(2 downto 0);
    --SIGNAL CDB_QBuffer 					:STD_LOGIC_VECTOR (4 downto 0);
    --SIGNAL CDB_VBuffer 					:STD_LOGIC_VECTOR (31 downto 0);
    --SIGNAL CDB_BufferRequest 			:STD_LOGIC;

begin
    IU : IssueUnit port map ( 
        IssueIn 			=> IssueIn,
        FUType 				=> FUType,
        Fop 				=> Fop,
        Ri 					=> Ri,
        Rj 					=> Rj,
        Rk 					=> Rk,
        RFReadAddr1 		=> IssueUnit_RFReadAddr1,
        RFReadAddr2 		=> IssueUnit_RFReadAddr2,
        RFTag 				=> IssueUnit_RFTag,
        RFAddrW 			=> IssueUnit_RFAddrW,
        RFWrEn 				=> IssueUnit_RFWrEn,
        Accepted 			=> IssueUnit_Accepted,
        OpOut 				=> IssueUnit_OpOut,
        ArithmeticAvailable => Arithmetic_Available,
        ArithmeticIssue 	=> IssueUnit_ArithmeticIssue,
        LogicalAvailable 	=> Logical_Available,
        LogicalIssue 		=> IssueUnit_LogicalIssue,
        BufferAvailable 	=> Buffer_Available,
        BufferIssue 		=> IssueUnit_BufferIssue,
        RoBFull => ROB_FullOut,
        Clk 				=> CLK,
        Rst 				=> RST);   

    Accepted <= IssueUnit_Accepted ;
    Buffer_Available <= BufferAvailable ;

    A : Arithmetic Port Map (
        RST 			=> RST,
        CLK 			=> CLK,
        Issue 		=> IssueUnit_ArithmeticIssue ,
        Op 			=> IssueUnit_OpOut,
        Vj 			=> VjSignal,
        Vk 			=> VkSignal,
        Qj 			=> QjSignal,
        Qk 			=> QkSignal,
        CDBV 		=> CDB_Vout,
        CDBQ 		=> CDB_Qout,
        Grant 		=> CDB_GrantArithmetic,
        Available 	=> Arithmetic_Available,
        VOut 		=> Arithmetic_VOut,
        QOut 		=> Arithmetic_QOut,
        RequestOut 	=> Arithmetic_RequestOut);
    
    L : Logical Port map (
        RST 			=> RST,
        CLK 			=> CLK,
        Issue 		=> IssueUnit_LogicalIssue,
        Op 			=> IssueUnit_OpOut,
        Vj 			=> VjSignal,
        Vk 			=> VkSignal,
        Qj 			=> QjSignal,
        Qk 			=> QkSignal,
        CDBV 		=> CDB_Vout,
        CDBQ 		=> CDB_Qout,
        Grant 		=> CDB_GrantLogical,
        Available 	=> Logical_Available,
        VOut 		=> Logical_VOut,
        QOut 		=> Logical_QOut,
        RequestOut 	=> Logical_RequestOut);


    RF : RegisterFile port Map (
        ReadAddr1 	=> IssueUnit_RFReadAddr1,
        ReadAddr2 	=> IssueUnit_RFReadAddr2,
        AddrW 		=> ROB_RFAddr,
        RFWrData	=> ROB_RFWrData,
        WrEn 		=> ROB_RFWrEn,
        Clk 		=> Clk,
        Rst 		=> Rst,
        DataOut1 	=> RF_DataOut1,
        DataOut2 	=> RF_DataOut2);

    CDBC : CDB port map (
        QArithmetic 			=> Arithmetic_QOut,
        VArithmetic 			=> Arithmetic_VOut,
        QLogical 			=> Logical_QOut,
        VLogical 			=> Logical_VOut,
        QBuffer 				=> CDB_QBuffer,
        VBuffer 				=> CDB_VBuffer,
        ArithmeticRequest 	=> Arithmetic_RequestOut,
        LogicalRequest 		=> Logical_RequestOut,
        BufferRequest 		=> CDB_BufferRequest,
        Clk 					=> Clk,
        Rst 					=> Rst,
        Qout 				=> CDB_Qout,
        Vout 				=> CDB_Vout,
        GrantArithmetic		=> CDB_GrantArithmetic,
        GrantLogical			=> CDB_GrantLogical,
        GrantBuffer			=> CDB_GrantBuffer);

    ROB: ReorderBuffer Port map (
        InstrTypeIn     => FUType,
        DestinationIn   => IssueUnit_RFAddrW,
        TagIn           => IssueUnit_RFTag,
        PCIn            => PCIn,
        ExceptionIn     => ExceptionIn,
        CDBQ            => CDB_Qout,
        CDBV            => CDB_Vout,
        WrEn            => IssueUnit_RFWrEn,
        ReadAddr1       => IssueUnit_RFReadAddr1,
        ReadAddr2       => IssueUnit_RFReadAddr2,
        Clk             => Clk,
        Rst             => Rst,
        RFAddr          => ROB_RFAddr,
        RFWrData        => ROB_RFWrData,
        RFWrEn          => ROB_RFWrEn,
        Exc             => Exception,
        InstrTypeOut    => InstrTypeOut,
        PCOut           => PCOut,    
        FullOut         => ROB_FullOut,
        DataOut1        => ROB_DataOut1,
        TagOut1         => ROB_TagOut1,
        Available1      => ROB_Available1,
        DataOut2        => ROB_DataOut2,
        TagOut2         => ROB_TagOut2,
        Available2      => ROB_Available2);

    with ROB_Available1 select
        VjSignal <= ROB_DataOut1    when '1', 
                    RF_DataOut1     when others;

    with ROB_Available1 select
        QjSignal <= ROB_TagOut1    when '1', 
                    "00000"        when others;
                    
    with ROB_Available2 select
        VkSignal <= ROB_DataOut2    when '1', 
                    RF_DataOut2     when others;                
        
    with ROB_Available2 select
        QkSignal <= ROB_TagOut2    when '1', 
                    "00000"        when others;
end Behavioral;