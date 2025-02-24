--============================================================================================================================
--=== Tỷ lệ chạm khách hàng (Dịch vụ CA-IVAN và Tên miền)
--=== Theo vb34 BSC ban hành - Tỷ lệ chạm khách hàng (Dịch vụ CA-IVAN và Tên miền):
--=== Công thức = Số lượng ID nghiệp vụ thực hiện quá hạn & tồn chưa xử lý quá hạn / Tổng YCKH trên ID163-164
--=== * Tồn chưa xử lý quá hạn = Tổng YCKH trên ID163-164 - Số lượng ID nghiệp vụ thực hiện - Số lượng ID nghiệp vụ KH hẹn
--=== Chỉ tiêu này Hội và Duyên đã thống nhất sử dụng NGÀY RA PHIẾU để tính.
--=== Cho nên Số lượng ID nghiệp vụ thực hiện chỉ tiêu này sẽ khác Số lượng ID nghiệp vụ thực hiện chỉ tiêu CSKHH_004
--=== THEO BUOI HOP NGÀY 28/11/2024 - SỐ GIAO TÍNH THEO MỨC ĐỘ HOÀN THÀNH 100%
--============================================================================================================================
--===
-- Số lượng công tác nghiệp vụ,  hậu mãi, CSKH
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = 202502 and ten_kpi like 'Tỷ lệ chạm khách hàng (Dịch vụ CA-IVAN và Tên miền)';
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = 202502 and ma_kpi in ('HCM_TL_CSKH_001');
--=== KIEM TRA VTCV THEO MA_KPI - KIỂM TRA ĐẠ ĐỦ VỊ TRÍ CV NHƯ THEO VB HAY CHƯA
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = 202502 and ma_kpi = 'HCM_TL_CSKH_001' Order by GIAMDOC_PHOGIAMDOC, TO_TRUONG_PHO;

--=== VTCV NV
Select * from TTKD_BSC.nhanvien
where thang = 202502 and donvi = 'TTKD'
      and ma_vtcv in ('VNP-HNHCM_KHDN_3','VNP-HNHCM_BHKV_41','VNP-HNHCM_KHDN_18','VNP-HNHCM_BHKV_6','VNP-HNHCM_KHDN_23'); --347 nv: 310 nv tinh_bsc = 1 + 37 nv tinh_bsc = 0
--=== VTCV TO TRUONG
Select * from TTKD_BSC.nhanvien
where thang = 202502 and donvi = 'TTKD'
      and ma_vtcv in ('VNP-HNHCM_KHDN_4','VNP-HNHCM_BHKV_51','VNP-HNHCM_BHKV_42'); --46 nv: 44 nv tinh_bsc = 1 + 2 nv tinh_bsc = 0
--=== VTCV PGĐ
Select * from TTKD_BSC.nhanvien
where thang = 202502 and donvi = 'TTKD'
      and ma_vtcv in ('VNP-HNHCM_KHDN_1','VNP-HNHCM_KHDN_2','VNP-HNHCM_BHKV_1','VNP-HNHCM_BHKV_2.1','VNP-HNHCM_BHKV_2'); --39 nv: 38 nv tinh_bsc = 1 + 1 nv tinh_bsc = 0

Select * From ttkd_bsc.blkpi_dm_to_pgd@ttkddb where thang = 202502 and ma_pb = 'VNP0703000';

--====================================================================================================--
--===== CẬP NHẬT BẢNG LƯƠNG KPI THEO VỊ TRÍ CÔNG VIỆC
--===== Select * From bangluong_kpi
--===== MÃ KPI = HCM_TL_CSKH_001 ==> dành cho nhân viên
--===== THEO BUOI HOP NGÀY 28/11/2024 - SỐ GIAO TÍNH THEO MỨC ĐỘ HOÀN THÀNH 100%
--====================================================================================================--
Select * From ttkd_bsc.bangluong_kpi Where thang = 202502 and MA_KPI = 'HCM_TL_CSKH_001' Order by ma_pb, ma_vtcv; --432
--=====
Update ttkd_bsc.bangluong_kpi a
	Set a.CHITIEU_GIAO = 100, a.DONVI_TINH = '%'
Where a.THANG = 202502
	  and a.MA_KPI = 'HCM_TL_CSKH_001'
	  and exists (	Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where THANG = 202502
						  and MA_KPI in ('HCM_TL_CSKH_001')						-- <== LƯU Ý MÃ KPI
						  --and GIAMDOC_PHOGIAMDOC is null						-- <== LƯU Ý VỊ TRÍ CẬP NHẬT
					      and MA_VTCV = a.MA_VTCV );
Commit;
--====================================================================================================--
Select * From TTKD_BSC.BLKPI_DANHMUC_KPI Where thang = 202502 and NGUOI_XULY = 'Khanh' and ma_kpi = 'HCM_TL_CSKH_001';
--===
Update TTKD_BSC.BLKPI_DANHMUC_KPI
    Set giao = 1, DIEM_CONG = 1, DIEM_TRU = 1
Where thang = 202502
      and NGUOI_XULY = 'Khanh'
      and ma_kpi in ('HCM_TL_CSKH_001');
Commit;
--====================================================================================================--



--====================================================================================================--
--Drop Table SO_GIAO_TONG;
--Create Table SO_GIAO_TONG as (
--    Select (202502)THANG, 'HCM_TL_CSKH_001' ma_kpi, nv.ma_nv, nv.ma_to, nv.ma_pb
--		   , a.*
--    From (  select nv_nhan_id, count(*)sl
--			from ttkdhcm_ktnv.yckh_chuyenxl a
--            where a.tientrinhxl>0
--                  and a.nv_nhan_id in (select nhanvien_id from ttkdhcm_ktnv.yckh_nvob_cskh1 where tinh_sanluong=1)
--                  and a.ngayxl >= trunc(add_months(trunc(sysdate), -1),'mm')
--                  and a.ngayxl < trunc(add_months(trunc(sysdate), -0),'mm')
--            group by a.nv_nhan_id
--         ) a
--    Left join ttkd_bsc.nhanvien nv On thang = 202502 and donvi = 'TTKD' and a.NV_NHAN_ID = nhanvien_id
--);
--===    

