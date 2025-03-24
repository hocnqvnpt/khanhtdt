--====================================================================================================
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ten_kpi like 'Tỷ lệ nghiệp vụ xử lý quá hạn';
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001';
--=====
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001'; --02 vt NV ; 1 vt PGD ; 2 vt TT ; 1 vt Truong ca
Select * From ttkd_bsc.nhanvien
--Select distinct ten_to From ttkd_bsc.nhanvien
where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD'                       -- 10 nv ; 2 pgđ ; 1 trường ca ; 2 tổ trưởng
      and ma_vtcv in ('VNP-HNHCM_KDOL_16.3','VNP-HNHCM_KDOL_22','VNP-HNHCM_KDOL_2','VNP-HNHCM_KDOL_24.1','VNP-HNHCM_KDOL_18','VNP-HNHCM_KDOL_23');
Select * From ttkd_bsc.bangluong_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001'; -- 10 nv ; 1 pgđ (loai tru Tuyet) ; 1 trường ca ; 2 tổ trưởng = 14 record


--====================================================================================================
--===== SỐ LIỆU GỐC TỪ HỘI
Select * From ttkdhcm_ktnv.yckh_bsc_xl_quahan a Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm');
Select distinct NGAYCAPNHAT From ttkdhcm_ktnv.yckh_bsc_xl_quahan a Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm'); -- ngày 07/03/2025, Hội chốt lại số liệu
Select NV_NHAN_MANV_HRM, count(*)sl From ttkdhcm_ktnv.yckh_bsc_xl_quahan a Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') Group by NV_NHAN_MANV_HRM Having count(*)>1; -- null => OK

--===== ĐƯA VÀO BẢNG LƯU CHỐT SỐ LIỆU ĐỂ TÍNH BSC
Select * From BSC_TON_QUAHAN Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm');

Delete From BSC_TON_QUAHAN Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001';

Insert Into BSC_TON_QUAHAN
(
    Select a.THANG, 'HCM_SL_BHOL_001' MA_KPI, 'Tỷ lệ nghiệp vụ xử lý quá hạn' TEN_KPI
           , nv.ma_pb, nv.ten_pb, nv.ma_to, nv.ten_to, a.NV_NHAN_MANV_HRM ma_nv, nv.ten_nv, nv.ma_vtcv, nv.ten_vtcv, nv.tinh_bsc
           , a.TONG, DA_XL_TRONGHAN, a.HEN_XL, a.CHUAXL_QUAHAN, a.CHUAXL_TRONGHAN, a.TONG_THUEBAO_DAXL
           , nvl(a.DA_XL_QUAHAN,0)DA_XL_QUAHAN
           , nvl(a.DA_XL_QUAHAN,0) + nvl(CHUAXL_QUAHAN,0) KQ_TON_QUAHAN		-- CHUAXL_QUAHAN: Hội xác nhận đã loại trừ KH_HEN
           , sysdate NGAY_CN
		   , a.NGAYCAPNHAT
    From ttkdhcm_ktnv.yckh_bsc_xl_quahan a
    Left join ttkd_bsc.nhanvien nv On nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and nv.donvi = 'TTKD' and nv.ma_nv = a.nv_nhan_manv_hrm
    Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
);
Commit;
/* ----------------------------------------------------
   -- Update theo yêu cầu P.BHONL - Mail của chị Thủy
   ---------------------------------------------------- */
Select * From BSC_TON_QUAHAN a Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and exists ( Select 1 From A_ONL Where a.ma_nv = ma_nv );
Update BSC_TON_QUAHAN a
    Set DA_XL = 25, DA_XL_QUAHAN = 0
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
      and a.ma_kpi = 'HCM_SL_BHOL_001'
      and a.ma_nv = 'VNP016926';
Commit;
Update BSC_TON_QUAHAN a
    Set KQ_TON_QUAHAN = 0
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
      and a.ma_kpi = 'HCM_SL_BHOL_001'
      and exists ( Select 1 From A_ONL Where a.ma_nv = ma_nv );
Commit;

--====================================================================================================
--===== ĐƯA LÊN ID88
Select * 
From (
        Select THANG, MA_PB, TEN_PB, MA_TO, TEN_TO, MA_NV, TEN_NV
               --, TONG, DA_XL DA_XL_TRONGHAN, HEN_XL, DA_XL_QUAHAN, CHUAXL_QUAHAN
			   , KQ_TON_QUAHAN
        From khanhtdt_ttkd.BSC_TON_QUAHAN
        Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
			  --and to_char(NGAY_CHOT_ID164,'yyyymmdd') = '20250115'
              and ma_kpi = 'HCM_SL_BHOL_001'
              and ma_pb = 'VNP0703000'
              and ma_to in ('VNP0703003', 'VNP0703005')
        Order by ten_to, ten_vtcv
     )
;
--====================================================================================================