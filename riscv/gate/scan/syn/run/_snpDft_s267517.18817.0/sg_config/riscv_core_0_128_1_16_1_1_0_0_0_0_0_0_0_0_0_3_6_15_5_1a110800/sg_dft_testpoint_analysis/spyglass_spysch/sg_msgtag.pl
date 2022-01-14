################################################################################
#This is an internally genertaed by SpyGlass for Message Tagging Support
################################################################################


use spyglass;
use SpyGlass;
use SpyGlass::Objects;
spyRebootMsgTagSupport();

spySetMsgTagCount(91,40);
spyCacheTagValuesFromBatch(["DFT_DATA_CSV_TAG"]);
spyCacheTagValuesFromBatch(["DFT_DSM_RRF_TP_TAG"]);
spyParseTextMessageTagFile("./sg_config/riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800/sg_dft_testpoint_analysis/spyglass_spysch/sg_msgtag.txt");

if(!defined $::spyInIspy || !$::spyInIspy)
{
    spyDefineReportGroupingOrder("ALL",
(
"BUILTIN"   => [SGTAGTRUE, SGTAGFALSE]
,"TEMPLATE" => "A"
)
);
}
spyMessageTagTestBenchmark(210,"./sg_config/riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800/sg_dft_testpoint_analysis/spyglass.vdb");

1;
