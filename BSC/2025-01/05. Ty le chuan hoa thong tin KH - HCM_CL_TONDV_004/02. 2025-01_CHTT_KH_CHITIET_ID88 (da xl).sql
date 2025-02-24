--===== MỤC DÍCH LÀ CẬP NHẬT VÀO BÀNG TONGHOP_BSC_KPI
--=== CHUẨN HÓA THÔNG TIN KH - SO GIAO VÀ SỐ THỰC HIỆN THEO FILE P.NVC GỬI
Select * From ttkd_bsc.nhanvien nv Where nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and nv.donvi = 'TTKD' and ma_nv = 'VNP028081';
Select * From BSC_CHTTKH_202501;
Select GHI_CHU, DEXUAT_LOAI, count(*) From BSC_CHTTKH_202501 Group by GHI_CHU, DEXUAT_LOAI;
Select GHI_CHU, DEXUAT_LOAI, DA_CHUANHOA, count(*) From BSC_CHTTKH_202501 Group by GHI_CHU, DEXUAT_LOAI, DA_CHUANHOA;
Select distinct bo_dau(GHI_CHU) From BSC_CHTTKH_202501;
--=== TEST TEN_PB và MA_PB có KHOP HAY KHONG ==> ma_pb_th OK ==> so luong tong OK
Select a.TEN_PB, a.ma_pb_th, (Select ten_pb From ttkd_bsc.dm_phongban Where active = 1 and ma_pb = a.ma_pb_th) ten_pb_2, count(a.ma_pb_th)SL
From BSC_CHTTKH_202501 a
Group by a.TEN_PB, a.ma_pb_th
Order by ten_pb_2;
--=== TEST GHI NHAN CHTT CO ma_tt_one NULL HAY KHONG
Select ma_tt_one From BSC_CHTTKH_202501 Where bo_dau(GHI_CHU) = 'GHI NHAN DA CHTT' and ma_tt_one is null; --KHÔNG DÒNG NÀO => OK
--=== TEST MA_NV_AM, TEN_PB có KHOP VOI BANG NHAN VIEN HAY KHONG ==> SOSANH = 0 ==> OK
Select * From (
    Select distinct a.ma_nv_am, a.ma_pb_th, nv.ma_pb, (case when a.ma_pb_th = nv.ma_pb then 0 else 1 end)SOSANH
    From BSC_CHTTKH_202501 a
    Left join ttkd_bsc.nhanvien nv On nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and nv.donvi = 'TTKD' and nv.ma_nv = a.ma_nv_am
)where sosanh = 1;

--====================================================================================================
--=== SO THUC HIEN CA NHAN đưa lên web123 ID88
Select * From (
    Select MA_PB_TH, TEN_PB, TEN_TO, MA_NV_AM, TEN_NV, TEN_VTCV, TAP_DS, MA_TT_ONE, NGAY_CAPNHAT_ONE, GHI_CHU
    From khanhtdt_ttkd.BSC_CHTTKH_202501 a
    Order by da_chuanhoa desc, TEN_PB, TEN_TO
);

--=== SO THUC HIEN PHONG DE LAM BAO CAO đưa lên web123 ID88
    Select a.ma_pb_th, a.ten_pb
           --, GIAO, SOTHUCHIEN
           , round( (SOTHUCHIEN*100)/GIAO, 2 ) TYLE
    From (  
            Select ma_pb_th, (Select ten_pb From ttkd_bsc.dm_phongban Where active = 1 and ma_pb = ma_pb_th)ten_pb
                   , sum(SO_GIAO)GIAO
            From khanhtdt_ttkd.BSC_CHTTKH_202501
            Group by ma_pb_th
         ) a
    Left join
        (	
            Select ma_pb_th, sum(da_chuanhoa)SOTHUCHIEN
            From khanhtdt_ttkd.BSC_CHTTKH_202501
            Group by ma_pb_th
         ) b
    On a.ma_pb_th = b.ma_pb_th
    Order by a.ten_pb
;
--====================================================================================================
