--===== MỤC DÍCH LÀ CẬP NHẬT VÀO BÀNG LUONG KPI
--===== THEO VTCT VÀ MA KPI
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ten_kpi like 'Số lượng cuộc gọi OB thành công'; --202410 => HCM_CL_TNGOI_006
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi like 'HCM_CL_TNGOI_006'; -- => OK
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_006'); -- => tháng 10/2024: chỉ có NV CSKH TS (ONL)
Select * From ttkd_bsc.nhanvien Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_vtcv in ('VNP-HNHCM_KDOL_24'); --4 nv - 2 nv tinh_bsc = 1
--=== KIEM TRA TỔ DO PGD PHỤ TRÁCH - THEO DANH MUC KPI VỊ TRÍ CÔNG VIỆC
--=== vb tháng 2024-08 P.NS, ma kpi HCM_CL_TNGOI_006 không tính vị trí Tổ trưởng và PGD phụ trách
--=== da yeu cau Hoc bỏ 2 nv này khỏi bàng lương kpi thì tinh_bsc = 0
Select * From TTKD_BSC.bangluong_kpi Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_006') and ma_nv in ('CTV088293','CTV087920');
Select * From ttkd_bsc.nhanvien Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_vtcv in ('VNP-HNHCM_KDOL_24') and ma_nv in ('CTV088293','CTV087920');
--====================================================================================================--
--===== CẬP NHẬT BẢNG LƯƠNG THEO VỊ TRÍ CÔNG VIỆC - MÃ KPI = HCM_CL_TNGOI_006
--=== Buoc 3: update so luong thue bao cai Vi or MM vao bang luong, view ID88, gui Nhan su
--====================================================================================================--
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_006'); and loai = 1;
Select * From TTKD_BSC.bangluong_kpi Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_006'); --and THUCHIEN > 0; -- 02 nv tinh bsc
--=====
Update TTKD_BSC.bangluong_kpi a
	Set a.THUCHIEN = null, a.TYLE_THUCHIEN = null, a.MUCDO_HOANTHANH = null
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TNGOI_006')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select * From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TNGOI_006')
						  and MA_VTCV = a.MA_VTCV );
Commit;
--========== SỐ THỰC HIỆN CÁ NHÂN
Update TTKD_BSC.bangluong_kpi a
	Set a.THUCHIEN
		= (
			Select distinct SO_THUCHIEN
			From TONGHOP_BSC_KPI_2024
			Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
				  and ma_kpi in ('HCM_CL_TNGOI_006')
				  and loai = 1
				  and ma_nv = a.ma_nv
		  )
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TNGOI_006')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select * From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TNGOI_006')
						  and giamdoc_phogiamdoc is null
						  and MA_VTCV = a.MA_VTCV );
Commit;
--=== TY LE THUC HIEN
Update TTKD_BSC.bangluong_kpi a
	Set a.TYLE_THUCHIEN
		= Round ( (THUCHIEN * 100) / GIAO, 2)
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TNGOI_006')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select * From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TNGOI_006')
						  and giamdoc_phogiamdoc is null
						  and MA_VTCV = a.MA_VTCV );
Commit;
--=== MUC DO HOAN THANH
Update TTKD_BSC.bangluong_kpi a
	Set a.MUCDO_HOANTHANH
         = (Case when TYLE_THUCHIEN >= 70 then (Case when TYLE_THUCHIEN > 120 then 120 else TYLE_THUCHIEN end)
                 when TYLE_THUCHIEN >= 40 and TYLE_THUCHIEN < 70 then 0.5*TYLE_THUCHIEN
                 when TYLE_THUCHIEN < 40 then 0.25*TYLE_THUCHIEN
            end)
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TNGOI_006')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select * From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TNGOI_006')
						  and giamdoc_phogiamdoc is null
						  and MA_VTCV = a.MA_VTCV );
Commit;
--========== TỔ TRƯỞNG
--=== vb tháng 2024-08 P.NS, ma kpi HCM_CL_TNGOI_006 không tính vị trí Tổ trưởng và PGD phụ trách
--========== PHÓ GIÁM ĐỐC
--=== vb tháng 2024-08 P.NS, ma kpi HCM_CL_TNGOI_006 không tính vị trí Tổ trưởng và PGD phụ trách
--=== TEST SAU KHI CAP NHA BANG LUONG
Select ma_pb, ma_to, ma_nv, ten_vtcv, giao, thuchien, tyle_thuchien, mucdo_hoanthanh From TTKD_BSC.bangluong_kpi Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_006') and thuchien > 0;
Select loai, ma_nv, so_giao, so_thuchien, tyle, mucdo_ht From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_006') and loai = 1 and ma_nv = 'VNP016812';
--Select loai, ma_to, so_thuchien From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_006') and loai = 2 and ma_to = '';    --vb không có vi tri TT
--Select loai, ma_nv, so_thuchien From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_006') and loai = 3 and ma_nv = '';    --vb không có vi tri PGD
--====================================================================================================--

--====================================================================================================--
--===== KẾT QUẢ SOSANH = 0 HẾT TẤT CẢ => OK
--=== CA NHAN
Select * From (
    Select b.giao, b.MA_NV MA_NV_BANGLUONG, b.THUCHIEN
           , a.SO_THUCHIEN - b.THUCHIEN SOSANH_TH
           , a.MA_NV, a.SO_THUCHIEN
    From 
       (  Select *
            From TTKD_BSC.bangluong_kpi a
            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and MA_KPI = 'HCM_CL_TNGOI_006'
                  and exists (	Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                                Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                      and ma_kpi = 'HCM_CL_TNGOI_006'               -- <== LƯU Ý MÃ KPI
                                      and giamdoc_phogiamdoc is null                -- <== LƯU Ý VỊ TRÍ NV
                                      and to_truong_pho is null                     -- <== LƯU Ý VỊ TRÍ NV
                             )
       ) b
	Left join
       (  Select * from TONGHOP_BSC_KPI_2024 where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TNGOI_006' ) a
    On a.ma_nv = b.ma_nv
)Where SOSANH_TH > 0 Or SOSANH_TH is null;
--=== TO
--=== PGD
--====================================================================================================--