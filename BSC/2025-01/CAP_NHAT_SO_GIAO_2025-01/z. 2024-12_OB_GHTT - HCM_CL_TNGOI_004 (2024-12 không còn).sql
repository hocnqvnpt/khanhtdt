--===== MỤC DÍCH LÀ CẬP NHẬT VÀO BÀNG LUONG KPI
--===== THEO VTCT VÀ MA KPI
Select * From TTKD_BSC.blkpi_danhmuc_kpi_vtcv Where thang = 202412 and ma_kpi like 'HCM_CL_TNGOI_004'; -- thang 2024-12
Select * From ttkd_bsc.nhanvien Where thang = 202412 and ma_vtcv in ('VNP-HNHCM_KDOL_15') and tinh_bsc = 1; --56 nv
Select * From TTKD_BSC.BLKPI_DANHMUC_KPI Where thang = 202412 and ma_kpi = 'HCM_CL_TNGOI_004';

--====================================================================================================--
--===== CẬP NHẬT BẢNG LƯƠNG THEO VỊ TRÍ CÔNG VIỆC - MÃ KPI = HCM_CL_TNGOI_004
--====================================================================================================--
Select * From TTKD_BSC.BANGLUONG_KPI Where thang = 202412 and ma_kpi in ('HCM_CL_TNGOI_004') Order by ten_pb; --56 nv
--=====
Update TTKD_BSC.BANGLUONG_KPI a
	Set a.GIAO = null
Where a.thang = 202412
      and a.ma_kpi in ('HCM_CL_TNGOI_004')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = 202412
						  and ma_kpi in ('HCM_CL_TNGOI_004')
						  and MA_VTCV = a.MA_VTCV
				 );
Commit;
--========== SỐ GIAO CÁ NHÂN
Update TTKD_BSC.BANGLUONG_KPI a
	Set a.GIAO = NGAYCONG * 180
Where a.thang = 202412
	  and a.ma_kpi in ('HCM_CL_TNGOI_004')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = 202412
						  and ma_kpi in ('HCM_CL_TNGOI_004')
						  and giamdoc_phogiamdoc is null
						  and MA_VTCV = a.MA_VTCV
				 );
Commit;
--========== vb345 2024-12 kông có
--========== SỐ GIAO TỔ TRƯỞNG (Tổng định mức giao cho các NV theo LĐ thực tế)
--========== SỐ GIAO PHÓ GIÁM ĐỐC PHỤ TRÁCH (Tổng định mức giao cho các NV theo LĐ thực tế)
--====================================================================================================--
Select * From TTKD_BSC.BLKPI_DANHMUC_KPI Where thang = 202412 and ma_kpi = 'HCM_CL_TNGOI_004';
--===
Update TTKD_BSC.BLKPI_DANHMUC_KPI
    Set giao = 1, thuchien = 1
Where thang = 202412
      and upper(NGUOI_XULY) = 'KHANH'
      and ma_kpi in ('HCM_CL_TNGOI_004');
Commit;
--====================================================================================================--


