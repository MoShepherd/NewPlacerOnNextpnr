/*
Globalb
*/
#ifndef PLACER_LIQUID_H
#define PLACER_LIQUID_H
#include "log.h"
#include "nextpnr.h"

#include <functional>

NEXTPNR_NAMESPACE_BEGIN

struct PlacerLiquidCfg
{
    PlacerLiquidCfg(Context *ctx);

    int innerItrStart, innerItrEnd;
    float betaOne, betaTwo;
    double eps;
    int maxConnLength;
    float maxConnLengthRatio;
    int nOuterSparse, nOuterDense;
    double learningRateStart, learningRateStop;
    double anchorWeightStop, anchorWeightExponent;

    float alpha, beta;
    float criticalityExponent;
    float timingWeight;
    bool timing_driven;
    float solverTolerance;
    bool placeAllAtOnce;
    float netShareWeight;
    bool parallelRefine;
    bool chainRipup;
    int cell_placement_timeout;

    int hpwl_scale_x, hpwl_scale_y;
    int spread_scale_x, spread_scale_y;

    // These cell types will be randomly locked to prevent singular matrices
    pool<IdString> ioBufTypes;
    // These cell types are part of the same unit (e.g. slices split into
    // components) so will always be spread together
    std::vector<pool<BelBucketId>> cellGroups;

    // this is an optional callback to prioritise certain cells/clusters for legalisation
    std::function<float(Context *, CellInfo *)> get_cell_legalisation_weight = [](Context *, CellInfo *) { return 1; };

    bool disableCtrlSet;

    //Datastructure should contain all logic-block-types for calculation of utilisation of logic blocks. 
    //This is an important decision-value in placer liquid
    std::vector<BelBucketId> logicBlockTypes; 

    /*
    Control set API
    HeAP legalisation can be sped up by directly searching for nearby tiles to place an FF with a compatible control
    set. Only one shared control set is currently supported, however, as a full validity check is always performed too,
    this doesn't need to encompass every possible incompatibility (this is only for performance/QoR not correctness)

    ff_bel_bucket is the bel bucket ID for the flipflop (or logic cell if combined with LUT) bel type

    ff_control_set_groups contains the Z-location of flipflops in a control set group.
    Each entry in this represents a SLICE, i.e. the set of flipflops that share the control set. In XC7 this would be
    the two SLICEs in a tile.

    get_cell_control_set should return a unique index for every control set possibility. i.e. if this function returns
    the same value the flipflops could be placed in the same group.
    */

    BelBucketId ff_bel_bucket = BelBucketId();
    std::vector<std::vector<int>> ff_control_set_groups;

    // ctrl_set_max_radius is specified as a schedule per iteration, in general this should decrease over time
    std::vector<int> ctrl_set_max_radius;

    // TODO: control sets might have a hierarchy, like ultrascale+ CE vs CLK/SR
    std::function<int32_t(Context *, const CellInfo *)> get_cell_control_set = [](Context *, const CellInfo *) {
        return -1;
    };
};

extern bool placer_liquid(Context *ctx, PlacerLiquidCfg cfg);
NEXTPNR_NAMESPACE_END
#endif