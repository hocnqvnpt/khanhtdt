--===== MỤC DÍCH LÀ CẬP NHẬT VÀO BÀNG LUONG KPI
--====================================================================================================
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ten_kpi like 'Tỷ lệ nghiệp vụ xử lý quá hạn';
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001';
--=====
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001'; --02 vt NV ; 1 vt PGD ; 2 vt TT ; 1 vt Truong ca
Select * From ttkd_bsc.nhanvien
where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD'                       -- 10 nv ; 2 pgđ ; 1 trường ca ; 2 tổ trưởng = 15 nv 
      and ma_vtcv in ('VNP-HNHCM_KDOL_16.3','VNP-HNHCM_KDOL_22','VNP-HNHCM_KDOL_2','VNP-HNHCM_KDOL_24.1','VNP-HNHCM_KDOL_18','VNP-HNHCM_KDOL_23');
Select * From ttkd_bsc.bangluong_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001'; -- 10 nv ; 1 pgđ (loai tru Tuyet) ; 1 trường ca ; 2 tổ trưởng = 14 nv 

--====================================================================================================--
--=== CẬP NHẬT BẢNG LƯƠNG THEO VỊ TRÍ CÔNG VIỆC - MÃ KPI = HCM_SL_BHOL_001
--=== Buoc 3: update so luong thue bao cai Vi or MM vao bang luong, view ID88, gui Nhan su
--====================================================================================================--
Select * From TTKD_BSC.bangluong_kpi Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001' Order by ten_vtcv;
--=====
Update TTKD_BSC.bangluong_kpi a
	Set a.GIAO = null, a.THUCHIEN = null, a.TYLE_THUCHIEN = null, a.MUCDO_HOANTHANH = null
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi = 'HCM_SL_BHOL_001'
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi = 'HCM_SL_BHOL_001'
						  and MA_VTCV = a.MA_VTCV );
Commit;
--========== SỐ THỰC HIỆN - CÁ NHÂN theo MA_NV + loai = 1
Update TTKD_BSC.bangluong_kpi a
	Set (a.GIAO, a.THUCHIEN)
		= (
            Select distinct so_giao, so_thuchien
            From KHANHTDT_TTKD.tonghop_bsc_kpi_2024
            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and ma_kpi = 'HCM_SL_BHOL_001'
                  and loai = 1
                  and ma_nv = a.ma_nv
		  )
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi = 'HCM_SL_BHOL_001'
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi = 'HCM_SL_BHOL_001'
						  and giamdoc_phogiamdoc is null and to_truong_pho is null
						  and MA_VTCV = a.MA_VTCV );
Commit;
--========== SỐ THỰC HIỆN - TO TRUONG theo MA_NV + loai = 2
Update TTKD_BSC.bangluong_kpi a
	Set (a.GIAO, a.THUCHIEN)
		= (
            Select distinct so_giao, so_thuchien
            From KHANHTDT_TTKD.tonghop_bsc_kpi_2024
            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and ma_kpi = 'HCM_SL_BHOL_001'
                  and loai = 2
                  and ma_nv = a.ma_nv
		  )
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi = 'HCM_SL_BHOL_001'
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi = 'HCM_SL_BHOL_001'
						  and to_truong_pho = 1
						  and MA_VTCV = a.MA_VTCV );
Commit;
--========== SỐ THỰC HIỆN - PHO GIAM DOC theo MA_NV + loai = 3
Update TTKD_BSC.bangluong_kpi a
	Set (a.GIAO, a.THUCHIEN)
		= (
            Select distinct so_giao, so_thuchien
            From KHANHTDT_TTKD.tonghop_bsc_kpi_2024
            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and ma_kpi = 'HCM_SL_BHOL_001'
                  and loai = 3
                  and ma_nv = a.ma_nv
		  )
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi = 'HCM_SL_BHOL_001'
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi = 'HCM_SL_BHOL_001'
						  and giamdoc_phogiamdoc = 1
						  and MA_VTCV = a.MA_VTCV );
Commit;
--=== TY LE THUC HIEN
Update TTKD_BSC.bangluong_kpi a
	Set a.TYLE_THUCHIEN
        = (Case when Round( (thuchien*100)/giao, 2) >= 100 then Round( (thuchien*100)/giao, 2)
                when Round( (thuchien*100)/giao, 2) < 100 then 100 - Round( (thuchien*100)/giao, 2)
           End) 
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi = 'HCM_SL_BHOL_001'
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi = 'HCM_SL_BHOL_001'
						  and MA_VTCV = a.MA_VTCV );
Commit;
--=== MUC DO HOAN THANH
Update TTKD_BSC.bangluong_kpi a
    Set a.MUCDO_HOANTHANH
        = (Case when a.TYLE_THUCHIEN >= 99 then 100
                when (a.TYLE_THUCHIEN >= 60 and a.TYLE_THUCHIEN < 99) then Round(a.TYLE_THUCHIEN * 0.5, 2)
                when a.TYLE_THUCHIEN < 60 then Round(a.TYLE_THUCHIEN * 0.25, 2)
           End)
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi = 'HCM_SL_BHOL_001'
	  and exists (	--=== CAP NHAT THEO VỊ TRÌ CV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi = 'HCM_SL_BHOL_001'
						  and MA_VTCV = a.MA_VTCV );
Commit;
--====================================================================================================--
Select THANG, TEN_KPI, TEN_TO, MA_NV, TEN_NV, MA_VTCV, TEN_VTCV, GIAO, THUCHIEN, TYLE_THUCHIEN, MUCDO_HOANTHANH
From TTKD_BSC.bangluong_kpi Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001' Order by ma_to, ten_vtcv;
--=== Test sau khi cap nhat
Select loai, ma_nv, so_giao, so_thuchien, tyle, mucdo_ht From KHANHTDT_TTKD.tonghop_bsc_kpi_2024
Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001' and loai = 1 and ma_nv = 'CTV082208'; --OK
Select loai, ma_nv, so_giao, so_thuchien, tyle, mucdo_ht From KHANHTDT_TTKD.tonghop_bsc_kpi_2024
Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001' and loai = 2 and ma_to = 'VNP0703003'; --OK
Select loai, ma_nv, so_giao, so_thuchien, tyle, mucdo_ht From KHANHTDT_TTKD.tonghop_bsc_kpi_2024
Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001' and loai = 3 and ma_nv = 'VNP017072'; --OK
--====================================================================================================--

--====================================================================================================--
--===== KẾT QUẢ SOSANH = 0 HẾT TẤT CẢ => OK
Select a.thang, a.MA_NV MA_NV_BANGLUONG, a.giao, a.thuchien
	   , a.thuchien - b.so_thuchien SOSANH_TH
	   , b.thang, b.ma_nv, b.so_thuchien
From TTKD_BSC.bangluong_kpi a
Left join ( Select * From KHANHTDT_TTKD.tonghop_bsc_kpi_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001' and loai = 1 ) b
On a.ma_nv = b.ma_nv
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
      and a.ma_kpi = 'HCM_SL_BHOL_001'
      and a.ma_vtcv in ('VNP-HNHCM_KDOL_16.3','VNP-HNHCM_KDOL_22');
--====================================================================================================--
Select a.thang, a.MA_NV MA_NV_BANGLUONG, a.giao, a.thuchien
	   , a.thuchien - b.so_thuchien SOSANH_TH
	   , b.thang, b.ma_nv, b.so_thuchien
From TTKD_BSC.bangluong_kpi a
Left join ( Select * From KHANHTDT_TTKD.tonghop_bsc_kpi_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001' and loai = 2 ) b
On a.ma_nv = b.ma_nv
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
      and a.ma_kpi = 'HCM_SL_BHOL_001'
      and a.ma_vtcv in ('VNP-HNHCM_KDOL_23','VNP-HNHCM_KDOL_18','VNP-HNHCM_KDOL_24.1');
--====================================================================================================--
Select a.thang, a.MA_NV MA_NV_BANGLUONG, a.giao, a.thuchien
	   , a.thuchien - b.so_thuchien SOSANH_TH
	   , b.thang, b.ma_nv, b.so_thuchien
From TTKD_BSC.bangluong_kpi a
Left join ( Select * From KHANHTDT_TTKD.tonghop_bsc_kpi_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001' and loai = 3 ) b
On a.ma_nv = b.ma_nv
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
      and a.ma_kpi = 'HCM_SL_BHOL_001'
      and a.ma_vtcv in ('VNP-HNHCM_KDOL_2');
--====================================================================================================--