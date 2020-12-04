Higher-order noise correlation utilities in Matlab v1.0-beta.

https://zenodo.org/badge/latestdoi/316573748

horc1.0-beta. Current revision of this text 23 Nov 2020. Under the terms of the MIT license: https://opensource.org/licenses/MIT
by Emili Balaguer-Ballester et al. (see citation below)  https://staffprofiles.bournemouth.ac.uk/display/eb-ballester

Balaguer Lab 

Faculty of Science and Technology, Interdisciplinary neuroscience research centre, Bournemouth University. https://research.bournemouth.ac.uk/centre/interdisciplinary-neuroscience-research/

Citation for this code: Balaguer-Ballester, E., Nogueira, R., Abofalia, J.M., Moreno-Bote, R. Sanchez-Vives, M.V., 2020. Representation of Foreseeable Choice Outcomes in Orbitofrontal Cortex Triplet-wise Interactions. Plos Computational Biology, 16(6): e1007862.

Requirements: Matlab © 2018 or more recent, parallel computing and statistics and machine learning libraries.
.\
Functions.
diffCorr: Calculates the differential correlation shown in the supplementary methods (Methods S1, Figure S5)
get_period: Retrieves a specific temporal period during the trial
noiseCorr: Standard noise correlations
noiseCorr_3rdorder: Triplet-wise Pearson noise correlations
noiseCorr_4thorder: Quadruplet-wise Pearson noise correlations
noiseCorr_5thorder: Fifth-order Pearson noise correlations
variabilitySingleUnits: Plots of rates, variances, fano factors.
plotLines, plotAllLines: Trivial display functions to plot lines delimiting specific periods
residualsDataset: Trival regression from the previous trial to remove autocorrelation (Methods eqn. 2).

.\example
Batch files and examples 
BatchDifferentialCorrel: Demonstrates the differential correlation in specific period of the trials (Methods S1, Figure S5)
BatchBasicStatsCorrelSign: Demonstrates the comparison of sings of correlations e.g., Figures 6, 7, S4 
basicStatsCorrelSign: Provides stats to compare the sign of correlations
BatchBasicStatsVariability: Provides stats to compare means of correlations absolute magnitude e.g., Fig. S1
BatchExamples: Demostrates single-unit and correlation plots
renumTrials, plotFinalAverages: Auxiliary functions for the previous batch file
----------------------------------------------------------------------------------------------------------------------------------------------

License shadedErrorBar.m function
Copyright (c) 2014, Rob Campbell
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the distribution
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
