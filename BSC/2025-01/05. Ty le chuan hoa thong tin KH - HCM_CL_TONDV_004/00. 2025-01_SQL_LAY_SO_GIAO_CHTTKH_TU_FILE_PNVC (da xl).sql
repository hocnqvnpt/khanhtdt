--====================================================================================================--
--=== CHUẨN HÓA THÔNG TIN KH - SO GIAO VÀ SỐ THỰC HIỆN THEO FILE P.NVC GỬI VERSION 4_NEW
Select * From ttkd_bsc.nhanvien nv Where nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and nv.donvi = 'TTKD';
Select * From BSC_CHTTKH_202501; --229 khớp file NVC
--=== TEST CHUAN HOA - CHUA CHUAN HOA
Select GHI_CHU, DEXUAT_LOAI, sum(DA_CHUANHOA)DA_CHUANHOA, sum(SO_GIAO)SO_GIAO From BSC_CHTTKH_202501 Group by GHI_CHU, DEXUAT_LOAI;
Select distinct bo_dau(GHI_CHU) From BSC_CHTTKH_202501;
Select distinct bo_dau(DEXUAT_LOAI) From BSC_CHTTKH_202501;
--=== TEST TEN_PB và MA_PB có KHOP HAY KHONG ==> ma_pb_th OK ==> so luong tong OK
Select a.TEN_PB, a.ma_pb_th, (Select ten_pb From ttkd_bsc.dm_phongban Where active = 1 and ma_pb = a.ma_pb_th) ten_pb_2
       , sum(a.so_giao)so_giao, sum(a.da_chuanhoa)da_chuanhoa
       , round( (sum(a.da_chuanhoa) / sum(a.so_giao) * 100), 2) TY_LE
From BSC_CHTTKH_202501 a
Group by a.TEN_PB, a.ma_pb_th
Order by ten_pb;
--=== TEST GHI NHAN CHTT CO ma_tt_one NULL HAY KHONG
Select ma_tt_one From BSC_CHTTKH_202501 Where bo_dau(GHI_CHU) = 'GHI NHAN DA CHTT' and ma_tt_one is null; --KHÔNG DÒNG NÀO => OK
--====================================================================================================
--=== UPDATE MA_TO, MA_VTCV theo MA_NV_AM
Update BSC_CHTTKH_202501 a
	Set (MA_TO, MA_VTCV, TINH_BSC)
		= ( Select distinct ma_to, ma_vtcv, tinh_bsc
			From ttkd_bsc.nhanvien nv
			Where nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
				  and nv.donvi = 'TTKD'
				  and nv.ma_nv = a.ma_nv_am
		  )
Where a.MA_TO is null or a.MA_VTCV is null or a.TINH_BSC is null;
Commit;
--=== TEST có MA_NV_AM
Select ma_tt_one, ma_nv_am, ma_pb_th, ma_to, ma_vtcv, tinh_bsc From BSC_CHTTKH_202501 Where ma_nv_am is not null and ma_vtcv is null;
--====================================================================================================
--=== SỐ GIAO NV
Select ma_nv_am, ten_vtcv, sum(so_giao)SOGIAO_NV From BSC_CHTTKH_202501 Group by ma_nv_am, ten_vtcv;
--=== SỐ GIAO PHONG ==> OK KHOP VOI FILE EXCEL v1
Select ma_pb_th, ten_pb, sum(so_giao)SOGIAO_PHONG From BSC_CHTTKH_202501 Group by ma_pb_th, ten_pb Order by ten_pb;

--====================================================================================================
Select * From BSC_SOGIAO_KPI Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TONDV_004';
Delete From BSC_SOGIAO_KPI Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TONDV_004';
Commit;
Insert Into BSC_SOGIAO_KPI
(   THANG, MA_KPI, LOAI, LOAI_KPI, MA_PB, MA_TO, MA_NV, MA_VTCV, SOGIAO )
(
    Select (to_char(trunc(sysdate, 'month')-1, 'yyyymm'))thang, 'HCM_CL_TONDV_004' MA_KPI, (1)LOAI, 'KPI_NV' LOAI_KPI
           , a.ma_pb_th, a.ma_to, a.ma_nv_am, a.ma_vtcv, a.SOGIAO
    From 
         (
            Select ma_pb_th, ma_to, ma_nv_am, ma_vtcv, sum(so_giao)SOGIAO
            From BSC_CHTTKH_202501
            Group by ma_pb_th, ma_to, ma_nv_am, ma_vtcv
         ) a
);
Commit;
--=== SO GIAO TO TRUONG -- Lưu ý 3 Phòng Cho Lon , Cu Chi, Sai Gon không có Tổ trưởng Tổ Kinh doanh dịch vụ CNTT
Insert Into BSC_SOGIAO_KPI
(   THANG, MA_KPI, LOAI, LOAI_KPI, MA_PB, MA_TO, MA_NV, MA_VTCV, SOGIAO )
(
    Select a.THANG, 'HCM_CL_TONDV_004' MA_KPI, (2)LOAI, 'KPI_TO' LOAI_KPI, a.MA_PB, a.MA_TO, a.MA_NV, a.MA_VTCV, b.SOGIAO
    From (
            Select THANG, MA_PB, MA_TO, MA_NV, MA_VTCV
            From ttkd_bsc.nhanvien nv
            Where nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and nv.donvi = 'TTKD'
                  and exists (	--=== CAP NHAT THEO VTCV
                                Select * From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                                Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                      and ma_kpi in ('HCM_CL_TONDV_004')
                                      and to_truong_pho = 1
                                      and MA_VTCV = nv.MA_VTCV )
            Order by MA_PB, MA_TO, MA_NV
         ) a
    Left join
        (
            Select MA_TO, sum(SOGIAO)SOGIAO
            From BSC_SOGIAO_KPI
            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and ma_kpi = 'HCM_CL_TONDV_004'
                  and loai = 1
            Group by MA_TO
        ) b
    On a.MA_TO = b.MA_TO
    Where b.SOGIAO is not null
);
Commit;
/*
--=== SO GIAO PGD PHỤ TRÁCH TỔ
Insert Into BSC_SOGIAO_KPI
(
    Select THANG, 'HCM_CL_TONDV_004' MA_KPI, (3)LOAI, 'KPI_PB' LOAI_KPI, MA_PB, (null)MA_TO, MA_NV, MA_VTCV, sum(SOGIAO)SOGIAO, 'TO' PHUTRACH
    From (
            Select a.THANG, a.MA_PB, a.MA_TO, a.MA_NV, a.MA_VTCV, b.SOGIAO
            From (	--===== MA_NV PHÓ GIÁM ĐỐC PHỤ TRÁCH TỔ
                    Select thang, ma_pb, ma_to, ma_nv, ma_vtcv
                    From ttkd_bsc.blkpi_dm_to_pgd a
                    where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') 
                          and ma_kpi = 'HCM_CL_TONDV_004'
                          and upper(phutrach) = 'TO'
                          and exists (  --=== LẤY VỊ TRÍ PGĐ TRONG BẢNG DANH MỤC
                                        Select * From ttkd_bsc.blkpi_danhmuc_kpi_vtcv
                                        Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                              and ma_kpi = 'HCM_CL_TONDV_004'
                                              and GIAMDOC_PHOGIAMDOC = 1
                                              and ma_vtcv = a.ma_vtcv )
                    Group by thang, ma_pb, ma_to, ma_nv, ma_vtcv
                 ) a
            Left join
                (   
                    Select MA_TO, sum(SOGIAO)SOGIAO
                    From BSC_SOGIAO_KPI
                    Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                          and ma_kpi = 'HCM_CL_TONDV_004'
                          and loai = 1
                    Group by MA_TO
                ) b
            On a.MA_TO = b.MA_TO
         )
    Where SOGIAO is not null
    Group by THANG, MA_PB, MA_NV, MA_VTCV
);
Commit;
--=== SO GIAO PGD PHỤ TRÁCH PHÒNG
--Select * From BSC_SOGIAO_KPI Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TONDV_004' and loai = 3 and PHUTRACH = 'PHONG';
--Delete From BSC_SOGIAO_KPI Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TONDV_004' and loai = 3 and PHUTRACH = 'PHONG';
Insert Into BSC_SOGIAO_KPI
(
    Select THANG, 'HCM_CL_TONDV_004' MA_KPI, (3)LOAI, 'KPI_PB' LOAI_KPI, MA_PB, (null)MA_TO, MA_NV, MA_VTCV, sum(SOGIAO)SOGIAO, 'PHONG' PHUTRACH
    From (
            Select a.THANG, a.MA_PB, a.MA_NV, a.MA_VTCV, b.SOGIAO
            From (	--===== MA_NV PHÓ GIÁM ĐỐC PHỤ TRÁCH PHÒNG
                    Select thang, ma_pb, ma_nv, ma_vtcv
                    From ttkd_bsc.blkpi_dm_to_pgd a
                    where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') 
                          and ma_kpi = 'HCM_CL_TONDV_004'
                          and upper(phutrach) = 'PHONG'
                          and exists (  --=== LẤY VỊ TRÍ PGĐ TRONG BẢNG DANH MỤC
                                        Select * From ttkd_bsc.blkpi_danhmuc_kpi_vtcv
                                        Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                              and ma_kpi = 'HCM_CL_TONDV_004'
                                              and GIAMDOC_PHOGIAMDOC = 1
                                              and ma_vtcv = a.ma_vtcv )
                    Group by thang, ma_pb, ma_nv, ma_vtcv
                 ) a
            Left join
                (   
                    Select MA_PB, sum(SOGIAO)SOGIAO
                    From BSC_SOGIAO_KPI
                    Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                          and ma_kpi = 'HCM_CL_TONDV_004'
                          and loai = 1
                    Group by MA_PB
                ) b
            On a.MA_PB = b.MA_PB
         )
    Where SOGIAO is not null
    Group by THANG, MA_PB, MA_NV, MA_VTCV
);
Commit;
*/