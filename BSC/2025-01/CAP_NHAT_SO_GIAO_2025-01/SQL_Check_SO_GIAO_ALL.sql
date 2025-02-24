
--=====
--Select THANG, MA_KPI, TEN_KPI, MA_NV, TEN_NV, GIAO From TTKD_BSC.BANGLUONG_KPI Where thang = 202412 and ma_kpi in ('HCM_CL_TNGOI_004') Order by ten_pb; --56 nv
Select THANG, MA_KPI, TEN_KPI, MA_NV, TEN_NV, MA_VTCV, TYTRONG, CHITIEU_GIAO, GIAO, DONVI_TINH
From TTKD_BSC.BANGLUONG_KPI Where thang = 202412 and ma_kpi = 'HCM_CL_TNGOI_006' Order by ten_pb; --2 nv
--=====
Select THANG, MA_KPI, TEN_KPI, MA_NV, TEN_NV, MA_VTCV, TYTRONG, CHITIEU_GIAO, GIAO, DONVI_TINH
From ttkd_bsc.bangluong_kpi Where thang = 202412 and MA_KPI = 'HCM_SL_CSKHH_004' Order by ma_pb, ma_vtcv;
Select * From ttkd_bsc.nhanvien Where thang = 202412 and donvi ='TTKD' and ma_nv in ('CTV040506','CTV021930','CTV021919','CTV088522','CTV021898','CTV074972','CTV080933');
--=====
Select THANG, MA_KPI, TEN_KPI, MA_NV, TEN_NV, MA_VTCV, TYTRONG, CHITIEU_GIAO, GIAO, DONVI_TINH
From ttkd_bsc.bangluong_kpi Where thang = 202412 and MA_KPI = 'HCM_SL_BHOL_001' Order by ma_pb, ma_vtcv;
Select * From ttkd_bsc.bangluong_kpi Where thang = 202412 and MA_KPI = 'HCM_SL_BHOL_001' Order by ma_pb, ma_vtcv;
Select * From TTKD_BSC.BLKPI_DANHMUC_KPI Where thang = 202412 and ma_kpi = 'HCM_SL_BHOL_001';
--=====
Select THANG, MA_KPI, TEN_KPI, MA_NV, TEN_NV, MA_VTCV, TYTRONG, CHITIEU_GIAO, GIAO, DONVI_TINH
From ttkd_bsc.bangluong_kpi Where thang = 202412 and MA_KPI = 'HCM_TB_SIM4G_002' Order by ma_pb, ma_vtcv;  --198 nv 7 nv khong tinh bsc