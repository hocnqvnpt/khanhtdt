--===== MỤC DÍCH LÀ CẬP NHẬT VÀO BÀNG LUONG KPI
--===== THEO VTCT VÀ MA KPI
Select * From TTKD_BSC.blkpi_danhmuc_kpi_vtcv Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi like 'HCM_CL_TNGOI_004';
Select * From ttkd_bsc.nhanvien Where thang = 202409 and ma_vtcv in ('VNP-HNHCM_KDOL_15','VNP-HNHCM_KHDN_19');


--====================================================================================================--
--===== CẬP NHẬT BẢNG LƯƠNG THEO VỊ TRÍ CÔNG VIỆC - MÃ KPI = HCM_CL_TNGOI_004
--=== Buoc 3: update so luong thue bao cai Vi or MM vao bang luong, view ID88, gui Nhan su
--====================================================================================================--
Select * From TTKD_BSC.BANGLUONG_KPI Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_004') Order by ten_pb;
--=====
Update TTKD_BSC.BANGLUONG_KPI a
	Set a.GIAO = null
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
      and a.ma_kpi in ('HCM_CL_TNGOI_004')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TNGOI_004')
						  and MA_VTCV = a.MA_VTCV
				 );
Commit;
--========== SỐ GIAO CÁ NHÂN
Update TTKD_BSC.BANGLUONG_KPI a
	Set a.GIAO = 180 * a.NGAYCONG
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TNGOI_004')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TNGOI_004')
						  and giamdoc_phogiamdoc is null
						  and MA_VTCV = a.MA_VTCV
				 );
Commit;
--========== SỐ GIAO PHÓ GIÁM ĐỐC PHỤ TRÁCH (Tổng định mức giao cho các NV theo LĐ thực tế)
Update TTKD_BSC.BANGLUONG_KPI a
	Set a.GIAO
		=	(	--=== TONG SO GIAO NV THEO LĐ THỰC TẾ CÓ TRONG BÀNG LƯƠNG KPI
				Select sum(giao)
				From TTKD_BSC.BANGLUONG_KPI a
				Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
					  and a.ma_kpi in ('HCM_CL_TNGOI_004')
					  and exists (	Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
									Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
										  and ma_kpi in ('HCM_CL_TNGOI_004')
										  and giamdoc_phogiamdoc is null
										  and MA_VTCV = a.MA_VTCV
								 )
			)
	
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TNGOI_004')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TNGOI_004')
						  and giamdoc_phogiamdoc = 1
						  and MA_VTCV = a.MA_VTCV
				 );
Commit;
--====================================================================================================--


