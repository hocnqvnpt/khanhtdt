--===== Muc dich la Insert vào bàng bangluong_kpi
--===== theo VTCV và MA_KPI
-- Số lượng công tác nghiệp vụ,  hậu mãi, CSKH
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = 202501 and ten_kpi like 'Số lượng công tác nghiệp vụ, hậu mãi, CSKH';
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = 202501 and ma_kpi in ('HCM_SL_CSKHH_004');
--=== KIEM TRA VTCV THEO MA_KPI - KIỂM TRA ĐẠ ĐỦ VỊ TRÍ CV NHƯ THEO VB HAY CHƯA
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = 202501 and ma_kpi = 'HCM_SL_CSKHH_004';
Select * From ttkd_bsc.nhanvien
Where thang = 202501 and donvi = 'TTKD'
      and ma_vtcv in ('VNP-HNHCM_KDOL_22','VNP-HNHCM_KDOL_16.1','VNP-HNHCM_KDOL_16.2','VNP-HNHCM_KDOL_16.3') Order by ten_pb;  --28 nv tinh_bsc = 1- vb thang 11/2024 đã bỏ mã của KHDN


--====================================================================================================--
--===== CẬP NHẬT BẢNG LƯƠNG KPI THEO VỊ TRÍ CÔNG VIỆC
--===== Select * From bangluong_kpi where thang = 202409;
--===== MÃ KPI = HCM_SL_CSKHH_004 ==> dành cho nhân viên
--====================================================================================================--
Select * From ttkd_bsc.bangluong_kpi Where thang = 202501 and MA_KPI = 'HCM_SL_CSKHH_004' Order by ma_pb, ma_vtcv;
--=====
Update ttkd_bsc.bangluong_kpi a
	Set a.GIAO = null
Where a.THANG = 202501
	  and a.MA_KPI = 'HCM_SL_CSKHH_004'
	  and exists (	Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where THANG = 202501
						  and MA_KPI in ('HCM_SL_CSKHH_004')						-- <== LƯU Ý MÃ KPI
					      and MA_VTCV = a.MA_VTCV );
Commit;
--========== SỐ GIAO CÁ NHÂN - theo số trên vb quy định VNP-HNHCM_KDOL_22 = 1320
Update ttkd_bsc.bangluong_kpi a
	set a.GIAO = 1320, a.TYTRONG = 80, a.DONVI_TINH = 'Công viêc'
Where a.THANG = 202501
	  and a.MA_KPI = 'HCM_SL_CSKHH_004'
      and ma_vtcv in ('VNP-HNHCM_KDOL_22');
Commit;
--========== SỐ GIAO CÁ NHÂN - theo số trên vb quy định VNP-HNHCM_KDOL_16.1 = 100
Update ttkd_bsc.bangluong_kpi a
	set a.GIAO = 100, a.TYTRONG = 10, a.DONVI_TINH = 'Công viêc'
Where a.THANG = 202501
	  and a.MA_KPI = 'HCM_SL_CSKHH_004'
      and ma_vtcv in ('VNP-HNHCM_KDOL_16.1');
Commit;
--========== SỐ GIAO CÁ NHÂN - theo số trên vb quy định VNP-HNHCM_KDOL_16.2 = 150
Update ttkd_bsc.bangluong_kpi a
	set a.GIAO = 150, a.TYTRONG = 10, a.DONVI_TINH = 'Công viêc'
Where a.THANG = 202501
	  and a.MA_KPI = 'HCM_SL_CSKHH_004'
      and ma_vtcv in ('VNP-HNHCM_KDOL_16.2');
Commit;
--========== SỐ GIAO CÁ NHÂN - theo số trên vb quy định VNP-HNHCM_KDOL_16.3 = 1320
Update ttkd_bsc.bangluong_kpi a
	set a.GIAO = 1320, a.TYTRONG = 80, a.DONVI_TINH = 'Công viêc'
	Where a.THANG = 202501
	  and a.MA_KPI = 'HCM_SL_CSKHH_004'
      and ma_vtcv in ('VNP-HNHCM_KDOL_16.3');
Commit;
--========== SỐ GIAO TO TRUONG - vb345 tháng 2024-12 không có
--========== SỐ GIAO PGD PT - vb345 tháng 2024-12 không có
--====================================================================================================--
Select * From TTKD_BSC.BLKPI_DANHMUC_KPI Where thang = 202501 and ma_kpi = 'HCM_SL_CSKHH_004';
--===
Update TTKD_BSC.BLKPI_DANHMUC_KPI
    Set giao = 1, thuchien = 1
Where thang = 202501
      and upper(NGUOI_XULY) = 'KHANH'
      and ma_kpi in ('HCM_SL_CSKHH_004');
Commit;
--====================================================================================================--
