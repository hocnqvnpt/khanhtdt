--===== MỤC DÍCH LÀ CẬP NHẬT VÀO BÀNG LUONG KPI
--===== THEO VTCT VÀ MA KPI
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = 202501 and ten_kpi in ('Số lượng cuộc gọi OB thành công');
Select * From TTKD_BSC.blkpi_danhmuc_kpi_vtcv Where thang = 202501 and ma_kpi like 'HCM_CL_TNGOI_006';
Select * From ttkd_bsc.nhanvien Where thang = 202501 and ma_vtcv in ('VNP-HNHCM_KDOL_24') and tinh_bsc = 1; --2 nv

--====================================================================================================--
--===== CẬP NHẬT BẢNG LƯƠNG THEO VỊ TRÍ CÔNG VIỆC - MÃ KPI = HCM_CL_TNGOI_006
--=== Buoc 3: update so luong thue bao cai Vi or MM vao bang luong, view ID88, gui Nhan su
--====================================================================================================--
Select * From TTKD_BSC.BANGLUONG_KPI Where thang = 202501 and ma_kpi in ('HCM_CL_TNGOI_006') Order by ten_pb; --2 nv
--=====
Update TTKD_BSC.BANGLUONG_KPI a
	Set a.GIAO = null
Where a.thang = 202501
      and a.ma_kpi in ('HCM_CL_TNGOI_006')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = 202501
						  and ma_kpi in ('HCM_CL_TNGOI_006')
						  and MA_VTCV = a.MA_VTCV
				 );
Commit;
--========== SỐ GIAO CÁ NHÂN - theo số trên vb quy định 1020
Update TTKD_BSC.BANGLUONG_KPI a
	Set a.TYTRONG = 15, a.DONVI_TINH = 'Cuộc', a.GIAO = 1020
Where a.thang = 202501
	  and a.ma_kpi in ('HCM_CL_TNGOI_006')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = 202501
						  and ma_kpi in ('HCM_CL_TNGOI_006')
						  and giamdoc_phogiamdoc is null
						  and MA_VTCV = a.MA_VTCV
				 );
Commit;
--========== SỐ GIAO TỔ TRƯỞNG - vb345 2024-12 không có
--========== SỐ GIAO PGĐ phụ trách - vb345 2024-12 không có
--====================================================================================================--
Select * From TTKD_BSC.BLKPI_DANHMUC_KPI Where thang = 202501 and ma_kpi = 'HCM_CL_TNGOI_006';
--===
Update TTKD_BSC.BLKPI_DANHMUC_KPI
    Set giao = 1, thuchien = 1
Where thang = 202501
      and upper(NGUOI_XULY) = 'KHANH'
      and ma_kpi in ('HCM_CL_TNGOI_006');
Commit;
--====================================================================================================--
