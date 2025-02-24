--===== MỤC DÍCH LÀ CẬP NHẬT VÀO BÀNG LUONG KPI
--===== THEO VTCT VÀ MA KPI
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ten_kpi like 'Tỷ lệ chuẩn hóa thông tin khách hàng';
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004');
--=== KIEM TRA VTCV THEO MA_KPI - KIỂM TRA ĐẠ ĐỦ VỊ TRÍ CV NHƯ THEO VB HAY CHƯA
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TONDV_004';
Select distinct phutrach From ttkd_bsc.blkpi_dm_to_pgd where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TONDV_004';

--====================================================================================================--
--=== CẬP NHẬT BẢNG LƯƠNG THEO VỊ TRÍ CÔNG VIỆC - MÃ KPI = HCM_CL_TONDV_004
--=== Buoc 3: update so luong thue bao cai Vi or MM vao bang luong, view ID88, gui Nhan su
--====================================================================================================--
Select * From TTKD_BSC.BANGLUONG_KPI Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004');
--=====
Update TTKD_BSC.BANGLUONG_KPI a
	Set a.GIAO = null, a.THUCHIEN = null, a.TYLE_THUCHIEN = null, a.MUCDO_HOANTHANH = null, a.DIEM_CONG = null, a.DIEM_TRU = null
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TONDV_004')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TONDV_004')
						  and MA_VTCV = a.MA_VTCV );
Commit;
--========== SỐ THỰC HIỆN - CA NHÂN theo MA_NV
Update TTKD_BSC.BANGLUONG_KPI a
	Set (a.GIAO, a.THUCHIEN)
		= (
            Select distinct so_giao, so_thuchien
            From TONGHOP_BSC_KPI_2024
            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and ma_kpi in ('HCM_CL_TONDV_004')
                  and loai = 1
                  and ma_nv = a.ma_nv
		  )
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TONDV_004')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TONDV_004')
						  and giamdoc_phogiamdoc is null
						  and to_truong_pho is null
						  and MA_VTCV = a.MA_VTCV );
Commit;
--========== SỐ THỰC HIỆN - TO TRUONG theo MA_TO
Update TTKD_BSC.BANGLUONG_KPI a
	Set (a.GIAO, a.THUCHIEN)
		= (
            Select distinct so_giao, so_thuchien
            From TONGHOP_BSC_KPI_2024
            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and ma_kpi in ('HCM_CL_TONDV_004')
                  and loai = 2
                  and ma_to = a.ma_to
		  )
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TONDV_004')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TONDV_004')
						  and to_truong_pho = 1
						  and MA_VTCV = a.MA_VTCV );
Commit;
--========== SỐ THỰC HIỆN - PHO GIAM DOC PHỤ TRACH PHÒNG
Update TTKD_BSC.BANGLUONG_KPI a
	Set (a.GIAO, a.THUCHIEN)
		= (
            Select distinct so_giao, so_thuchien
            From TONGHOP_BSC_KPI_2024
            where THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and MA_KPI = 'HCM_CL_TONDV_004'
                  and loai = 3
                  and upper(phutrach) = 'PHONG'
                  and MA_NV = a.MA_NV
		  )
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TONDV_004')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TONDV_004')
						  and giamdoc_phogiamdoc = 1
						  and MA_VTCV = a.MA_VTCV );
Commit;
--========== SỐ THỰC HIỆN - PHO GIAM DOC PHỤ TRACH TỔ
Update TTKD_BSC.BANGLUONG_KPI a
	Set (a.GIAO, a.THUCHIEN)
		= (
            Select distinct so_giao, so_thuchien
            From TONGHOP_BSC_KPI_2024
            where THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and MA_KPI = 'HCM_CL_TONDV_004'
                  and loai = 3
                  and upper(phutrach) = 'TO'
                  and MA_NV = a.MA_NV
		  )
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TONDV_004')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TONDV_004')
						  and giamdoc_phogiamdoc = 1
						  and MA_VTCV = a.MA_VTCV )
	  and a.THUCHIEN is null;
Commit;

--=== TY LE THUC HIEN - MUC DO HOAN THANH
Update TTKD_BSC.BANGLUONG_KPI a
	Set a.TYLE_THUCHIEN = Round( (thuchien*100)/giao, 2)
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TONDV_004')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TONDV_004')
						  and MA_VTCV = a.MA_VTCV );
Commit;
--=== MUC DO HOAN THANH
Update TTKD_BSC.BANGLUONG_KPI a
    Set a.MUCDO_HOANTHANH = a.TYLE_THUCHIEN
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TONDV_004')
	  and exists (	--=== CAP NHAT THEO VỊ TRÌ CV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TONDV_004')
						  and MA_VTCV = a.MA_VTCV );
Commit;
--=== DIEM CONG TRU - theo vb32 mới
Update TTKD_BSC.BANGLUONG_KPI a
    Set  a.DIEM_CONG = (Case when MUCDO_HOANTHANH >= 100 then 0 end)
        , a.DIEM_TRU = (Case when MUCDO_HOANTHANH < 100  then 2 else 0 end)
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TONDV_004')
	  and exists (	--=== CAP NHAT THEO VỊ TRÌ CV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TONDV_004')
						  and MA_VTCV = a.MA_VTCV );
Commit;
--====================================================================================================--
Select * From TTKD_BSC.BANGLUONG_KPI Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004') and thuchien > 0 Order by ten_pb;
--=== Test sau khi cap nhat
Select ma_pb, ma_to, ma_nv, ten_vtcv, thuchien From TTKD_BSC.BANGLUONG_KPI Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004') and thuchien > 0;
Select loai, ma_nv, so_thuchien From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004') and loai = 1 and ma_nv = 'VNP017659'; --OK
Select loai, ma_nv, so_thuchien From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004') and loai = 2 and ma_to = 'VNP0702412'; --OK
Select loai, ma_nv, so_thuchien From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004') and loai = 3 and ma_nv = 'VNP022082'; --OK
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
                  and MA_KPI = 'HCM_CL_TONDV_004'
                  and exists (	Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                                Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                      and ma_kpi = 'HCM_CL_TONDV_004'               -- <== LƯU Ý MÃ KPI
                                      and giamdoc_phogiamdoc is null                -- <== LƯU Ý VỊ TRÍ NV
                                      and to_truong_pho is null                     -- <== LƯU Ý VỊ TRÍ NV
                             )
       ) b
	Left join
       (  Select * from TONGHOP_BSC_KPI_2024 where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TONDV_004' and loai = 1) a
    On a.ma_nv = b.ma_nv
)Where SOSANH_TH > 0 Or SOSANH_TH is null;
--=== TO TRUONG
Select * From (
    Select a.ma_to, a.so_thuchien
           , NVL(a.so_thuchien,0) - NVL(b.thuchien,0) SOSANH_TH
           , b.ma_to MA_NV_BANGLUONG, b.thuchien
           
    From (  Select * from TONGHOP_BSC_KPI_2024 where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TONDV_004' and loai = 2 ) a
    ,    (  Select *
            From TTKD_BSC.BANGLUONG_KPI a
            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and ma_kpi = 'HCM_CL_TONDV_004'
                  and exists (  Select 1 from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                                Where thang_kt is null
                                      and ma_kpi in ('HCM_CL_TONDV_004')
                                      and to_truong_pho = 1
                                      and ma_vtcv = a.ma_vtcv   )
        ) b
    Where a.ma_to = b.ma_to
) Where SOSANH_TH > 0;
--=== PGD
Select * From (
    Select a.ma_nv, a.so_thuchien
           , NVL(a.so_thuchien,0) - NVL(b.thuchien,0) SOSANH_TH
           , b.ma_nv MA_NV_BANGLUONG, b.thuchien
           
    From (  Select * from TONGHOP_BSC_KPI_2024 where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TONDV_004' and loai = 3 ) a
    ,    (  Select *
            From TTKD_BSC.BANGLUONG_KPI a
            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and ma_kpi = 'HCM_CL_TONDV_004'
                  and exists (  Select 1 from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                                Where thang_kt is null
                                      and ma_kpi in ('HCM_CL_TONDV_004')
                                      and giamdoc_phogiamdoc = 1
                                      and ma_vtcv = a.ma_vtcv   )
        ) b
    Where a.ma_nv = b.ma_nv
) Where SOSANH_TH > 0;
-- ====================================================================================================--
-- ========== END ========== --
-- ====================================================================================================--