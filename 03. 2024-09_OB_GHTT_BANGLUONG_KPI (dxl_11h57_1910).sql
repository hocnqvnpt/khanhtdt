--===== MỤC DÍCH LÀ CẬP NHẬT VÀO BÀNG LUONG KPI
--===== THEO VTCT VÀ MA KPI
Select * From TTKD_BSC.blkpi_danhmuc_kpi_vtcv Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi like 'HCM_CL_TNGOI_004';
Select * From ttkd_bsc.nhanvien Where thang = 202409 and ma_vtcv in ('VNP-HNHCM_KDOL_15','VNP-HNHCM_KHDN_19');
Select * From TTKD_BSC.BANGLUONG_KPI where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi like 'HCM_CL_TNGOI_004';
Select * from TONGHOP_BSC_KPI_2024 where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi like 'HCM_CL_TNGOI_004' and loai = 1;
Select * from TONGHOP_BSC_KPI_2024 where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi like 'HCM_CL_TNGOI_004' and loai = 2; -- => vb thang 09/2024 không tính vi tri to truong
Select * from TONGHOP_BSC_KPI_2024 where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi like 'HCM_CL_TNGOI_004' and loai = 3;


--====================================================================================================--
--===== CẬP NHẬT BẢNG LƯƠNG THEO VỊ TRÍ CÔNG VIỆC - MÃ KPI = HCM_CL_TNGOI_004
--=== Buoc 3: update so luong thue bao cai Vi or MM vao bang luong, view ID88, gui Nhan su
--====================================================================================================--
Select * From TTKD_BSC.BANGLUONG_KPI Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_004') Order by ten_pb;
--=====
Update TTKD_BSC.BANGLUONG_KPI a
	Set a.THUCHIEN = null, a.TYLE_THUCHIEN = null, a.MUCDO_HOANTHANH = null
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TNGOI_004')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TNGOI_004')
						  and MA_VTCV = a.MA_VTCV );
Commit;
--========== SỐ THỰC HIỆN - CA NHÂN VA PGD VÌ SỐ THỰC HIỆN THEO MA_NV
Update TTKD_BSC.BANGLUONG_KPI a
	Set a.THUCHIEN
		= (
            Select distinct so_thuchien
            From TONGHOP_BSC_KPI_2024
            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and ma_kpi in ('HCM_CL_TNGOI_004')
                  and loai in (1,3)
                  and ma_nv = a.ma_nv
		  )
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TNGOI_004')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TNGOI_004')
						  --and giamdoc_phogiamdoc is null
						  and MA_VTCV = a.MA_VTCV );
Commit;
--=== Test sau khi cap nhat
Select ma_pb, ma_to, ma_nv, ten_vtcv, thuchien From TTKD_BSC.BANGLUONG_KPI Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_004') and thuchien > 0;
Select loai, ma_nv, so_thuchien From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_004') and loai in (1,3) and ma_nv = 'CTV087580';
--====================================================================================================--
Select * From TTKD_BSC.BANGLUONG_KPI Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_004');
--=== TY LE THUC HIEN
Update TTKD_BSC.BANGLUONG_KPI a
	Set a.TYLE_THUCHIEN = Round((nvl(thuchien,0)*100)/giao, 2)
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TNGOI_004')
	  and exists (	--=== CAP NHAT THEO VTCV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TNGOI_004')
						  and MA_VTCV = a.MA_VTCV );
Commit;
--=== MUC DO HOAN THANH
Update TTKD_BSC.BANGLUONG_KPI a
    Set a.MUCDO_HOANTHANH
         = (Case when TYLE_THUCHIEN >= 100 then 120
                 when (TYLE_THUCHIEN >= 80 and TYLE_THUCHIEN < 100) then 100+(TYLE_THUCHIEN-80)
                 when (TYLE_THUCHIEN >= 50 and TYLE_THUCHIEN < 80)  then TYLE_THUCHIEN
                 when TYLE_THUCHIEN < 50 then 0
            end)     
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi in ('HCM_CL_TNGOI_004')
	  and exists (	--=== CAP NHAT THEO VỊ TRÌ CV
					Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and ma_kpi in ('HCM_CL_TNGOI_004')
						  and MA_VTCV = a.MA_VTCV );
Commit;
--====================================================================================================--
--===== KẾT QUẢ SOSANH = 0 HẾT TẤT CẢ => OK
--=== CA NHAN
Select * From (
    Select a.ma_nv, a.so_thuchien, a.tyle
           , NVL(a.so_thuchien,0) - NVL(b.thuchien,0) SOSANH_TH
           , NVL(a.tyle,0) - NVL(b.tyle_thuchien,0) SOSANH_TL
           , b.ma_nv MA_NV_BANGLUONG, b.thuchien, b.tyle_thuchien
           
    From (  Select * from TONGHOP_BSC_KPI_2024 where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TNGOI_004' and loai = 1 ) a
    ,    (  Select *
            From TTKD_BSC.BANGLUONG_KPI a
            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and ma_kpi = 'HCM_CL_TNGOI_004'
                  and exists (  Select 1 from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                                Where thang_kt is null
                                      and ma_kpi in ('HCM_CL_TNGOI_004')
                                      and to_truong_pho is null and giamdoc_phogiamdoc is null
                                      and ma_vtcv = a.ma_vtcv   )
        ) b
    Where a.ma_nv = b.ma_nv
) Where SOSANH_TH > 0 or SOSANH_TL > 0;
--====================================================================================================--
--TEST GIUA BANG LUONG VA BANG TONG HOP CAC TRUONG NULL
Select * From TTKD_BSC.BANGLUONG_KPI Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_004') and thuchien is null Order by ten_pb;
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
and ma_kpi in ('HCM_CL_TNGOI_004') and so_thuchien is null and ma_nv in ('CTV087789','CTV087779','CTV087758','CTV087584');
--====================================================================================================--