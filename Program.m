clc
close all
clear all
addpath(genpath('bosaris_toolkit'));
FileName= fopen('/home/ramesh/Desktop/Santosh/28-04-2017/TDSV_CDTW/Codes/Abhi_Code/Genscore_DTW_VQ.txt','r');
c=textscan(FileName,'%s %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d');
Names =c{1};
scores=[c{2} c{3} c{4} c{5} c{6} c{7} c{8} c{9} c{10} c{11} c{12} c{13} c{14} c{15} c{16}];