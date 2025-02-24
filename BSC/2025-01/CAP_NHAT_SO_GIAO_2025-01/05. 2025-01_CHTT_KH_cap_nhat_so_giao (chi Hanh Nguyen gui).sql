--===== Muc dich la Insert vào bàng bangluong_kpi
--===== theo VTCV và MA_KPI
-- Số lượng công tác nghiệp vụ,  hậu mãi, CSKH
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ten_kpi like 'Tỷ lệ chuẩn hóa thông tin khách hàng';
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004');
--=== KIEM TRA VTCV THEO MA_KPI - KIỂM TRA ĐẠ ĐỦ VỊ TRÍ CV NHƯ THEO VB HAY CHƯA
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TONDV_004';
Select * from TTKD_BSC.nhanvien
where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD'
      --and ma_vtcv in ('VNP-HNHCM_KHDN_3','VNP-HNHCM_BHKV_41','VNP-HNHCM_KHDN_23','VNP-HNHCM_BHKV_51','VNP-HNHCM_KHDN_4') and tinh_bsc = 1 --197 nv
      --and ma_vtcv in ('VNP-HNHCM_KHDN_3','VNP-HNHCM_BHKV_41','VNP-HNHCM_KHDN_23','VNP-HNHCM_BHKV_51','VNP-HNHCM_KHDN_4') and tinh_bsc = 0 --27 nv
;

--====================================================================================================--
--===== CẬP NHẬT BẢNG LƯƠNG KPI THEO VỊ TRÍ CÔNG VIỆC
--===== Select * From bangluong_kpi
--===== MÃ KPI = HCM_CL_TONDV_004 ==> dành cho nhân viên
--====================================================================================================--
Select * From ttkd_bsc.bangluong_kpi Where thang = 202501 and MA_KPI = 'HCM_CL_TONDV_004' Order by ma_pb, ma_vtcv;
--=====
Update ttkd_bsc.bangluong_kpi a
	Set a.DONVI_TINH = '%', CHITIEU_GIAO = 100
Where a.THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.MA_KPI = 'HCM_CL_TONDV_004'
	  and exists (	Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and MA_KPI in ('HCM_CL_TONDV_004')						-- <== LƯU Ý MÃ KPI
					      and MA_VTCV = a.MA_VTCV );
Commit;
--====================================================================================================--
