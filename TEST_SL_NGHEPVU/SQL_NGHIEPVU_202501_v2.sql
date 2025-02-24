/* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----BEGIN chọn các nghiệp vụ tính đơn giá-------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */
--truncate table ttkd_bsc.ct_bsc_nghiepvu ;
--create table ttkd_bsc.ct_bsc_nghiepvu as 
--select * from ttkd_bsc.ct_bsc_nghiepvu ;

/* -- TEST ĐỊNH DẠNG NGÀY THÁNG NĂM TRONG FILE ANH TUYỀN -- */
select distinct ngay_th From tuyenngo.SBH_CCOS_202501_CT Order by ngay_th;
select distinct THOI_GIAN_DOI From tuyenngo.SBH_ussd_202501_CT Order by THOI_GIAN_DOI;
select distinct NGAY_SUDUNG From tuyenngo.SBH_vinagift_202501_CT Order by NGAY_SUDUNG;

select * from ttkd_bsc.ct_bsc_nghiepvu where thang = 202501;
delete from ttkd_bsc.ct_bsc_nghiepvu where thang = 202501;
Commit;

/*	--khong chọn-------- VI VNPT ------------
	-- đã kiểm với anh Phương, tháng 01/2025 không có nv VNP phát triển
*/
insert into ttkd_bsc.ct_bsc_nghiepvu (THANG, MA_TB, NGAY_DKY_VI, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB, LOAI, TEN_LOAIHD)
    select a.THANG, ma_tb, ngay_dky_vi, donvi, ma_nv, ten_nv, ten_to, ten_pb, ten_vtcv, ma_vtcv, ma_to, ma_pb, cast('VI_VNPTPAY' as varchar(20)) loai, 'CAI VI' TEN_LOAIHD
    from ttkdhcm_ktnv.hcm_vnptpay_ketqua a
        join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and a.ma_hrm = nv.ma_nv and nv.thang = a.thang
    where ngay_dky_vi between to_date('01/01/2025 00:00:01','dd/mm/yyyy hh24:mi:ss') and to_date('31/01/2025 23:59:59', 'dd/mm/yyyy hh24:mi:ss')
          and ma_hrm is not null
    ;

/*	-- khong chọn------- MOBILE MONEY ------------
	-- đã kiểm với anh Phương, tháng 01/2025 không có nv VNP phát triển
*/
insert into ttkd_bsc.ct_bsc_nghiepvu (THANG, MA_TB, NGAY_DKY_VI, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB, LOAI, TEN_LOAIHD)
    select a.THANG, ma_tb, ngay_dky_mm, donvi, ma_nv, ten_nv, ten_to, TEN_PB, TEN_VTCV, MA_VTCV, ma_to, ma_pb, 'VI_VNPTMM' loai, 'CAI VI' TEN_LOAIHD
    from ttkdhcm_ktnv.hcm_vmoney_ketqua a
        join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and a.ma_hrm = nv.ma_nv and nv.thang = a.thang
    where ngay_dky_mm between to_date('01/01/2025 00:00:01','dd/mm/yyyy hh24:mi:ss') and to_date('31/01/2025 23:59:59','dd/mm/yyyy hh24:mi:ss') 
          and not exists (select * from ttkd_bsc.ct_bsc_nghiepvu ex where loai = 'VI_VNPTPAY' and a.ma_tb = ex.ma_tb)
;

/* ----khong chọn----- APP MYVNPT ------------*/
    insert into ttkd_bsc.ct_bsc_nghiepvu (THANG, MA_TB, NGAY_DKY_VI, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB, LOAI, TEN_LOAIHD)
        select a.THANG, ma_tb, ngay_active, donvi, ma_nv, ten_nv, ten_to, TEN_PB, TEN_VTCV, MA_VTCV, ma_to, ma_pb, 'APP_MYVNPT' loai, 'CAI APP' TEN_LOAIHD
        from ttkdhcm_ktnv.HCM_VNPTAPP_ACTIVE a
            join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and a.ma_hrm = nv.ma_nv and nv.thang = a.thang
        where ngay_active between to_date('01/01/2025 00:00:01','dd/mm/yyyy hh24:mi:ss') and to_date('31/01/2025 23:59:59','dd/mm/yyyy hh24:mi:ss') 
    ;
    commit ;

/*----HauMai-Muc 4-----CCOS - KHIEU NAI - TIEPNHAN--------
-- File tháng 01/2025 NGAY_TH anh Tuyen định dạng dd/mm/yyyy
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (thang, MA_PA, MA_TB, NGHIEPVU, USER_CCOS, TEN_LOAIHD, LOAI, NGAY_DKY_VI, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        select nv.thang, MA_PA, MA_TB, LOAI_KHIEUNAI || '; '|| LINHVUC_CHUNG || '; '|| LINHVUC_CON NGHIEPVU, a.USER_CCOS, 'KHIEU NAI - TIEP NHAN' TEN_LOAIHD, 'CCOS' loai
                    , to_date(NGAY_TH, 'dd/mm/yyyy hh24:mi') NGAY_TH, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
        from tuyenngo.SBH_CCOS_202501_CT a
            join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and a.USER_CCOS = nv.user_ccos and nv.thang = 202501
        where a.USER_CCOS is not null and TEN_LOAIHD = 'TIEPNHAN'
;

/*----Nghievu Khoan-----CCOS - KHIEU NAI - DA XU LY--------
-- File tháng 01/2025 NGAY_TH anh Tuyen định dạng dd/mm/yyyy
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (thang, MA_PA, MA_TB, NGHIEPVU, USER_CCOS, TEN_LOAIHD, LOAI, NGAY_DKY_VI, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        select nv.thang, MA_PA, MA_TB, LOAI_KHIEUNAI || '; '|| LINHVUC_CHUNG || '; '|| LINHVUC_CON NGHIEPVU, a.USER_CCOS, 'KHIEU NAI - DA XU LY' TEN_LOAIHD, 'CCOS' loai
                    , to_date(NGAY_TH, 'dd/mm/yyyy hh24:mi') NGAY_TH, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
        from tuyenngo.SBH_CCOS_202501_CT a
            join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and a.USER_CCOS = nv.user_ccos and nv.thang = 202501
        where a.USER_CCOS is not null and TEN_LOAIHD = 'DA XU LY'
    ;
commit ;

/* ------không ghi nhan------------ UPDATE USSD - DOISIM ------------------- 
-- thieu thông tin MA_KH, doi tuong KH ?? xu lý trên cùng 1 KH 
-- SMRS vao mail tap doan, VAO  PHAN TICH -> NHOM BAO CAO DOI SIM 4G -> BC CHI TIET DOI SIM 4G - hh24:mi:ss
-- File tháng 01/2025 THOI_GIAN_DOI anh Tuyen định dạng dd/mm/yyyy
*/
insert into ttkd_bsc.ct_bsc_nghiepvu (MA_TB, NGHIEPVU, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB)
	select SO_THUE_BAO, 'Doi sim ' ||SO_SIM_CU || '_' || SO_SIM_MOI nghiepvu, to_date(THOI_GIAN_DOI,'dd/mm/yyyy hh24:mi:ss') THOI_GIAN_DOI, 'DOI SIM' TEN_LOAIHD, 'USSD' loai
			, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
	from tuyenngo.SBH_ussd_202501_CT a
		join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and  a.MANV_HRM = nv.ma_nv and nv.thang = 202501
	where a.MANV_HRM is not null 
;
commit ;

/* ------HauMai-Muc 29------------ UPDATE VINAGIFT ------------------- 
-- web http://10.70.115.121/ -> tang qua -> bao cao voucher
-- File tháng 01/2025 NGAY_SUDUNG anh Tuyen định dạng dd/mm/yyyy
*/
insert into ttkd_bsc.ct_bsc_nghiepvu (MA_TB, NGHIEPVU, NGAY_DKY_VI, TEN_LOAIHD, LOAI, USER_CCOS, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
	select SO_SERI, MUCDICH_SD, to_date(NGAY_SUDUNG,'dd/mm/yyyy') NGAY_SUDUNG, 'VINAGIFT' TEN_LOAIHD, 'VINAGIFT' loai, MANV_CN
			, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
	from tuyenngo.SBH_vinagift_202501_CT a
		join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and  a.MANV_HRM = nv.ma_nv and nv.thang = 202501
;
commit;

/*----HauMai-Muc 3-----ONEBSS--- KHIEU NAI - TIEPNHAN -------------- 
--Chi xet khieu ai - TIEPNHAN
-- Theo MA_KN  
    --select * from NV_KHIEUNAI_202501_CT ;
    --drop table ttkd_bsc.x_temp_kn purge;
	--select * from ttkd_bsc.x_temp_kn;
    --select * from khanhtdt_ttkd.x_temp_kn; */
	
    drop table khanhtdt_ttkd.x_temp_kn purge;
	create table khanhtdt_ttkd.x_temp_kn aS
        select to_char(trunc(a.ngay_tn),'yyyymm') thang, a.donvi_id, a.thuebao_id, a.ma_tb,a.loaitb_id,a.dichvuvt_id,
                    a.ngay_tn, a.nguoi_cn, a.nhanvien_id, a.nhanvien_gq_id, MA_KN, ngay_GQ, TTKN_ID
        from qltn.v_khieunai@dataguard a
        where a.ngay_tn between to_date('01/01/2025','dd/mm/yyyy') and to_date('31/01/2025','dd/mm/yyyy')
	 ;

	insert into ttkd_bsc.ct_bsc_nghiepvu (THUEBAO_ID, KHACHHANG_ID, THANHTOAN_ID, MA_TB, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, ma_pa, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		select db.thuebao_id
				, db.khachhang_id, db.thanhtoan_id
				, a.ma_tb, kh.ma_kh, a.ngay_tn
				, 'KHIEU NAI - TIEPNHAN' TEN_LOAIHD, 'ONEBSS' loai, MA_KN
				, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
		from khanhtdt_ttkd.x_temp_kn a
			join css_hcm.db_thuebao db on db.thuebao_id = a.thuebao_id
			join css_hcm.db_khachhang kh on db.KHACHHANG_ID = kh.KHACHHANG_ID
			join admin_hcm.nhanvien vi on a.nhanvien_id = vi.nhanvien_id
			join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and vi.ma_nv = nv.ma_nv and a.thang = nv.thang
		where a.loaitb_id not in (20, 21)
	;
	commit ;
	
/*----Nghiep vu Khoan-----ONEBSS--- KHIEU NAI- HOAN THANH -------------- 
--Chi xet khieu ai - HOAN THANH
-- Theo MA_KN
	--drop table ttkd_bsc.x_temp_gqkn purge;
	--create table ttkd_bsc.x_temp_gqkn AS */
	
    drop table khanhtdt_ttkd.x_temp_gqkn purge;
	create table khanhtdt_ttkd.x_temp_gqkn aS 
        select to_char(trunc(a.ngay_gq),'yyyymm') thang, a.donvi_id, a.thuebao_id, a.ma_tb,a.loaitb_id,a.dichvuvt_id, a.ngay_tn, a.nguoi_cn, a.nhanvien_id, a.nhanvien_gq_id, MA_KN, ngay_GQ, TTKN_ID
        from qltn.v_khieunai@dataguard a
        where a.ngay_gq between to_date('01/01/2025','dd/mm/yyyy') and to_date('31/01/2025','dd/mm/yyyy')
	 ;
  	insert into ttkd_bsc.ct_bsc_nghiepvu (THUEBAO_ID, KHACHHANG_ID, THANHTOAN_ID, MA_TB, NGAY_DKY_VI, TEN_LOAIHD, LOAI, ma_pa, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		select db.thuebao_id
				, db.khachhang_id, db.thanhtoan_id
				, a.ma_tb, a.ngay_gq
				, 'KHIEU NAI- HOAN THANH' TEN_LOAIHD, 'ONEBSS' loai, MA_KN
				, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
		from khanhtdt_ttkd.x_temp_gqkn a
			join css_hcm.db_thuebao db on db.thuebao_id = a.thuebao_id
			join admin_hcm.nhanvien vi on a.nhanvien_id = vi.nhanvien_id
			join ttkd_bsc.nhanvien nv on vi.ma_nv = nv.ma_nv and a.thang = nv.thang
		where a.loaitb_id not in (20, 21)
	;
	commit ;
	
 /* ----Nghiep vu Khoan----------- ONEBSS - TIEP NHAN KHAO SAT DAT MOI ------------ 
-- theo MA_KH
-- lo?i tr? trùng ONEBSS - TIEP NHAN KHAO SAT DAT MOI voi ONEBSS - LAPDATMOI
-- update thêm  c?t MA_KH
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with bdk as
            ( select THANG, MA_KH, TEN_LOAIHD, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
					 , row_number() over(partition by MA_KH, nhanvien_id order by rowid) rnk
              from tuyenngo.sbh_202501_CT
			  where loaihd_id = 33 and tthd_id = 6 and MANV_RA_PCT is not null
			)
		select MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID
			   , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
		from bdk a
            join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
		where rnk = 1
	;
/* -----Nghiep vu Khoan---------- ONEBSS - TIEP NHAN LAP DAT MOI ------------ 
-- theo MA_KH
-- lo?i tr? trùng ONEBSS - TIEP NHAN LAP DAT MOI voi ONEBSS - LAPDATMOI
-- Update thêm c?t MA_KH
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with bdk as
            ( select THANG, MA_KH, TEN_LOAIHD, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
            		 , row_number() over(partition by MA_KH, nhanvien_id order by rowid) rnk
			  from tuyenngo.sbh_202501_CT
			  where loaihd_id = 26 and tthd_id = 6 and MANV_RA_PCT is not null
			)
		select MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID
			   , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
		from bdk a
			join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
		where rnk = 1
	;
/* -----Nghiep vu Khoan---------- ONEBSS - BIENDONGKHAC ------------ 
-- theo MA_KH
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with bdk as
            ( select THANG, MA_KH, TEN_LOAIHD, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
					 , row_number() over(partition by MA_KH, nhanvien_id order by rowid) rnk
              from tuyenngo.sbh_202501_CT
			  where loaihd_id = 11 and tthd_id = 6 and MANV_RA_PCT is not null
			)
		select MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID
               , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
		from bdk a
			join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
		where rnk = 1
	;
/* ----PTM-Muc 2--------- ONEBSS - BANTHIETBI ------------ 
-- Nghiem thu
-- theo thue bao
-- loai tru trong Nghiep vu LAPMOI
*/
    insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, hdkh_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        with tbl as
            ( select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, hdkh_id, MANV_RA_PCT, NGAY_YC
                     , row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
              from tuyenngo.sbh_202501_CT a
                join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
              where loaihd_id = 15 and tthd_id = 6 and MANV_RA_PCT is not null
            )
        select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id, hdkh_id
               , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
        from tbl a
            join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
        where rnk = 1
    ;
/* -----HauMai-Muc 1---------- ONEBSS - THANHLY ------------ 
-- Nghiem thu
-- theo thue bao
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tly as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
							, row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
					from tuyenngo.sbh_202501_CT a
						join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
					where loaihd_id = 4 and tthd_id = 6 and MANV_RA_PCT is not null
					)
		select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id
			   , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
		from tly a
			join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
		where rnk = 1
    ;
/* -----HauMai-Muc 2---------- ONEBSS - CHUYENQUYEN ------------ 
-- Nghiem thu
-- theo thue bao
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
							, row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
					from tuyenngo.sbh_202501_CT a
						join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
					where loaihd_id = 2 and tthd_id = 6 and MANV_RA_PCT is not null
					)
		select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id
				, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
		from tbl a
					join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
		where rnk = 1
	;
/* -------HauMai-Muc 23-------- ONEBSS - DICH CHUYEN ------------ 
    -- Nghiem thu
    -- theo thue bao*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
							, row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
					from tuyenngo.sbh_202501_CT a
						join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
					where loaihd_id = 3 and tthd_id = 6 and MANV_RA_PCT is not null
					)
		select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id
				, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
		from tbl a
			join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
		where rnk = 1
	;
/* ----HauMai-Muc 15----------- ONEBSS - KHOIPHUCTHANHLY ------------ 
    -- Nghiem thu
    -- theo thue bao*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
									, row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
							from tuyenngo.sbh_202501_CT a
											join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
							where loaihd_id = 30 and tthd_id = 6 and MANV_RA_PCT is not null
						)
			select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id
						, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
			from tbl a
						join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
			where rnk = 1
	;
/* ----PTM-Muc 1-----------ONEBSS -  LAPMOI ------------ 
-- Nghiem thu
-- theo thuebao*/
    insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, HDKH_ID, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        with tbl as(select THANG, ma_tb, MA_KH, TEN_LOAIHD, KHACHHANG_ID, thuebao_id, HDKH_ID, MANV_RA_PCT, NGAY_YC, dichvuvt_id, ma_duan
                                , row_number() over(partition by ma_tb, nhanvien_id order by NGAY_YC) rnk
                        from tuyenngo.sbh_202501_CT
                        where loaihd_id = 1 and tthd_id = 6 and MANV_RA_PCT is not null
                    )
        select ma_tb, MA_KH, ngay_yc
                    , case when dichvuvt_id in (1, 10, 11, 4, 7, 8, 9) then upper(bo_dau(TEN_LOAIHD)) || ' - BRCD'
                                when dichvuvt_id in (12, 13,14,15,16) and ma_duan is null then upper(bo_dau(TEN_LOAIHD)) || ' - CNTT'
                                when dichvuvt_id in (12, 13,14,15,16) and ma_duan is not null then upper(bo_dau(TEN_LOAIHD)) || ' - CNTTQLDA'
                                else TEN_LOAIHD end TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id, HDKH_ID
                    , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
        from tbl a
                    join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
        where rnk = 1
    ;
/* ----HauMai-Muc 24----------- ONEBSS - TACHNHAP ------------ 
-- Nghiem thu
-- theo KH*/
    insert into ttkd_bsc.ct_bsc_nghiepvu (ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        with tbl as(select THANG, MA_KH, TEN_LOAIHD, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
                                , row_number() over(partition by MA_KH, nhanvien_id order by rowid) rnk
                        from tuyenngo.sbh_202501_CT
                        where loaihd_id = 10 and tthd_id = 6 and MANV_RA_PCT is not null
                    )
        select MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID
                    , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
        from tbl a
                    join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
        where rnk = 1
        ;
/* -----Nghiep vu Khoan---------- ONEBSS - TAOMOIGOI_DADV ------------ 
-- Nghiem thu
-- theo theo ma_tb
-- lo?i trùng nghi?p v? L?P M?I/GHTT*/
    insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, hdkh_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
            with tbl as(select THANG, ma_tb, MA_KH, TEN_LOAIHD, KHACHHANG_ID, thuebao_id, hdkh_id, MANV_RA_PCT, NGAY_YC
                                    , row_number() over(partition by thuebao_id, nhanvien_id order by NGAY_YC) rnk
                            from tuyenngo.sbh_202501_CT
                            where loaihd_id = 27 and tthd_id = 6  and dichvuvt_id != 2 and MANV_RA_PCT is not null
                        )
            select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id, hdkh_id
                        , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
            from tbl a
                        join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
            where rnk = 1
    ;
	
/* ----- Không ghi nhận---------- ONEBSS - THAY DOI DAT COC ------------ 
-- Nghiem thu
-- theo thue bao
-- lo?i tr? trùng trong các nghi?p khác*/
    insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
                                , row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
                        from tuyenngo.sbh_202501_CT a
                                        join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
                        where loaihd_id = 32 and tthd_id = 6 and MANV_RA_PCT is not null
                    )
        select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id
                    , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
        from tbl a
                    join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
        where rnk = 1
    ;
/* ----- không ghi nhận------------ ONEBSS - DAT COC MOI ------------ 
-- theo MA_KH
-- lo?i tr? trùng ONEBSS - DAT COC MOI voi ONEBSS - LAPDATMOI, GHTT
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tbl as
            ( select THANG, MA_KH, TEN_LOAIHD, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
            		 , row_number() over(partition by MA_KH, nhanvien_id order by rowid) rnk
              from tuyenngo.sbh_202501_CT
			  where loaihd_id = 31 and tthd_id = 6 and MANV_RA_PCT is not null
			)
		select MA_KH, NGAY_YC, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID
               , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
		from tbl a
            join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
		where rnk = 1
	;
/* ----- không ghi nhận------------ ONEBSS - KY LAI HOP DONG GOC ----- */
    insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
                                , row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
                        from tuyenngo.sbh_202501_CT a
                                        join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
                        where loaihd_id = 24 and tthd_id = 6 and MANV_RA_PCT is not null
                    )
        select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id
               , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
        from tbl a
            join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
        where rnk = 1;
/* ----- không ghi nhận------------ ONEBSS - THAY THE/THU HOI/CAP BO SUNG VAT TU ----- */
    insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
                                , row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
                        from tuyenngo.sbh_202501_CT a
                                        join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
                        where loaihd_id = 13 and tthd_id = 6 and MANV_RA_PCT is not null
                    )
        select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id
               , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
        from tbl a
            join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
        where rnk = 1;
commit;

/* -----HauMai-Muc 16---------- ONEBSS - THAY DOI DICH VU ------------ 
-- Nghiem thu
-- theo thue bao
-- thay doi sau cung trong thang*/
    insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
                                        , row_number() over(partition by thuebao_id, a.nhanvien_id order by a.ngay_yc desc) rnk
                            from tuyenngo.sbh_202501_CT a
                                            join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
                            where loaihd_id = 7 and tthd_id = 6 and MANV_RA_PCT is not null
                    )
        select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id
                    , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
        from tbl a
                    join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
        where rnk = 1
    ;
/* -------Nghiep vu Khoan-------- ONEBSS - THAYDOI GOIDADICHVU ------------ 
-- Nghiem thu
-- theo kh
-- lo?i tr? trùng GHTT ** ch?a
*/
    insert into ttkd_bsc.ct_bsc_nghiepvu (ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        with tbl as(select a.THANG, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
                                        , row_number() over(partition by ma_kh, a.nhanvien_id order by a.ngay_yc) rnk
                            from tuyenngo.sbh_202501_CT a
                                            join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
                            where loaihd_id = 28 and tthd_id = 6 and MANV_RA_PCT is not null
                    )
        select MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID
                    , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
        from tbl a
                    join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
        where rnk = 1
    ;
/* --------HauMai-Muc 17,18------- ONEBSS - THAYDOI IMS MEGAWAN ------------ 
-- Nghiem thu
-- theo thue bao
*/
    insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
                                        , row_number() over(partition by MA_TB, a.nhanvien_id order by a.ngay_yc DESC) rnk
                            from tuyenngo.sbh_202501_CT a
                                            join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
                            where loaihd_id IN (21, 5) and tthd_id = 6 and MANV_RA_PCT is not null
                    )
        select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id
                    , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
        from tbl a
                    join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
        where rnk = 1
    ;
/* ------HauMai-Muc 19--------- ONEBSS - THAYDOI GIAHAN CNTT ------------ 
-- Nghiem thu
-- theo thue bao
--loại trừ trùng thue bao LAPMOI
*/
    insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
                           , row_number() over(partition by thuebao_id, a.nhanvien_id order by a.ngay_yc) rnk
                    from tuyenngo.sbh_202501_CT a
                        join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
                    where loaihd_id = 41 and tthd_id = 6 and MANV_RA_PCT is not null
                    )
        select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id
               , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
        from tbl a
			join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
        where rnk = 1
	;
/* ------HauMai-Muc 20,21--------- ONEBSS - THAYDOI TOCDO ADSL, TSL ------------ 
-- Nghiem thu
-- theo thue bao
-- Lo?i tr? trùng thue bao LAPMOI
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
										, row_number() over(partition by thuebao_id, a.nhanvien_id order by a.ngay_yc DESC) rnk
							from tuyenngo.sbh_202501_CT a
											join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
							where loaihd_id IN (8, 16) and tthd_id = 6 and MANV_RA_PCT is not null
					)
		select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id
					, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
		from tbl a
					join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
		where rnk = 1
	;
/* -----HauMai-Muc 27---------- ONEBSS - THUKHAC ------------ 
-- Nghiem thu
-- theo KH
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tbl as(select a.THANG, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
										, row_number() over(partition by ma_kh, a.nhanvien_id order by a.ngay_yc) rnk
							from tuyenngo.sbh_202501_CT a
											join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
							where loaihd_id = 17 and tthd_id = 6 and MANV_RA_PCT is not null
					)
		select MA_KH, ngay_yc,upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID
					, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
		from tbl a
					join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
		where rnk = 1
	;
			
/* ------HauMai-Muc 28--------- ONEBSS - THU CUOC ------------ 
-- Nghiem thu
-- theo KH theo ngay_tt
--loại trừ trùng ONEBSS - THU CUOC so v?i ONEBSS - Nghiep v? khac
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tbl as(    select a.THANG, MA_KH, TEN_LOAIHD, KHACHHANG_ID, ngay_tt
--									, MANV_RA_PCT, TENNV_RA_PCT, MA_VTCV, TEN_VTCV, MATO_RA_PCT, TENTO_RA_PCT, MAPB_RA_PCT, TENPB_RA_PCT
								, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
								, row_number() over(partition by ma_kh, a.nhanvien_id order by a.ngay_tt) rnk
						from tuyenngo.sbh_ct_thu_202501_ct a
							join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.donvi = 'TTKD' and nv.thang = a.THANG
						where MANV_RA_PCT is not null
					)
		select MA_KH, ngay_tt, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID
					, thang, donvi, ma_nv, ten_nv, ten_to, ten_pb, ten_vtcv, ma_vtcv, ma_to, ma_pb
		from tbl a
		where rnk = 1
	;
	
/* -----Nghiep vu Khoan----------ONEBSS - CHUYEN DOI LOAI HINH THUE BAO ------------ 
    -- Nghiem thu
    -- theo thue bao
    -- loai tr? theo danh sách VTTP có k? ho?ch chuy?n ??i*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tbl as(    select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
									, row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
							from tuyenngo.sbh_202501_CT a
                                join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
							where loaihd_id = 6 and tthd_id = 6 and MANV_RA_PCT is not null
						)
			select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id
						, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
			from tbl a
                join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
			where rnk = 1
			;
/* -----HauMai-Muc 10----------ONEBSS - DOISO/ACCOUNT ------------ 
    -- Nghiem thu
    -- theo thue bao*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tbl as(    select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
								, row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
						from tuyenngo.sbh_202501_CT a
							join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202501
						where loaihd_id = 14 and tthd_id = 6 and MANV_RA_PCT is not null
					)
		select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id
					, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
		from tbl a
			join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
		where rnk = 1
			;
/* -----PTM-Muc 3---------- CCBS - HMM TRA SAU  ------------ 
    -- Nghiem thu
    -- theo thue bao
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tbl as(    select nv.thang, ma_tb, MA_KH, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
								, row_number() over(partition by ma_tb, a.MANV_RA_PCT order by a.ngay_cn DESC) rnk
								, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
						from tuyenngo.sbh_vnp_202501_ct a
							join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501 
						where TEN_LOAIHD = 'HMM TRA SAU' and MANV_RA_PCT is not null
					)
		select ma_tb, MA_KH, ngay_cn, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'CCBS' loai 
					, thang, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
		from tbl
		where rnk = 1
		;
/* -----Nghiep vu Khoan---------- CCBS - CAP NHAT DB  ------------ 
    -- Nghiem thu
    -- theo thue bao
    */
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tbl as(    select nv.thang, ma_tb, MA_KH, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
								, row_number() over(partition by ma_tb, a.MANV_RA_PCT order by a.ngay_cn DESC) rnk
								, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
						from tuyenngo.sbh_vnp_202501_ct a
							join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501 
						where TEN_LOAIHD = 'CAP NHAT DB' and MANV_RA_PCT is not null
					)
		select ma_tb, MA_KH, ngay_cn, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'CCBS' loai 
					, thang, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
		from tbl
		where rnk = 1
		;

/* -----HauMai-Muc 22-------CCBS--- CNTTTB ------------ 
    -- Nghiem thu
    -- theo thue bao
    -- loai tr? trùng CCBS - Capnhat Danh ba
    */
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tbl as(    select nv.thang, ma_tb, MA_KH, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
								, row_number() over(partition by ma_tb, a.MANV_RA_PCT order by a.ngay_cn DESC) rnk
								, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
						from tuyenngo.sbh_vnp_202501_ct a
							join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501 
						where TEN_LOAIHD = 'CNTTTB' and MANV_RA_PCT is not null
					)
		select ma_tb, MA_KH, ngay_cn, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'CCBS' loai 
					, thang, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
		from tbl
		where rnk = 1
		;

/* -----HauMai-Muc 7---------- CCBS - DANG KY HUY CHUYEN DOI GOI CUOC ------------ 
    -- Nghiem thu
    -- theo KH, cập nhật ưu tiên
    -- ghi 1 lan/ngay
    -- thieu thong tin MA_KH, doi tuong KH de xu ly tren cung 1 KH de loc 100 nghiep vu
delete from ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd = 'DANG KY HUY CHUYEN DOI GOI CUOC' and thang = 202501;
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, doituong_id, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tbl as(    select nv.thang, ma_tb, MA_KH, doituong_id, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
									, row_number() over(partition by MA_KH, a.MANV_RA_PCT, trunc(a.ngay_cn) order by a.ngay_cn) rnk
									, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
							from tuyenngo.sbh_vnp_202501_ct a
								join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
							where TEN_LOAIHD = 'DANG KY HUY CHUYEN DOI GOI CUOC' and MANV_RA_PCT is not null and nvl(doituong_id, 1) in (1, 25)
						)
			select ma_tb, MA_KH, doituong_id, trunc(ngay_cn) ngay_cn, TEN_LOAIHD, 'CCBS' loai 
						, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
			from tbl
			where rnk = 1
	;
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, doituong_id, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tbl as(    select nv.thang, ma_tb, MA_KH, doituong_id, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
								   , nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
								   , row_number() over(partition by MA_KH, ma_tb, a.MANV_RA_PCT order by a.ngay_cn) rnk
							from tuyenngo.sbh_vnp_202501_ct a
								join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
							where TEN_LOAIHD = 'DANG KY HUY CHUYEN DOI GOI CUOC' and MANV_RA_PCT is not null and nvl(doituong_id, 1) not in (1, 25)
								)
			select ma_tb, MA_KH, doituong_id, trunc(ngay_cn) ngay_cn, TEN_LOAIHD, 'CCBS' loai 
						, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
			from tbl
			where rnk = 1
	;

/* ----HauMai-Muc 8----------- CCBS - DK NHOM DAI DIEN HUONG CUOC ------------ 
    -- Nghiem thu
    -- theo thue bao
*/
    insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        with tbl as(    select nv.thang, ma_tb, MA_KH, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
                                        , row_number() over(partition by ma_tb, a.MANV_RA_PCT order by a.ngay_cn) rnk
                                        , nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
                        from tuyenngo.sbh_vnp_202501_ct a
                                            join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
                        where TEN_LOAIHD = 'DK NHOM DAI DIEN HUONG CUOC' and MANV_RA_PCT is not null --and ma_kh = '010030778'
                    )
        select ma_tb, MA_KH, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
                    , THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
        from tbl
        where rnk = 1
    ;
    commit;
/* ---------HauMai-Muc 9------ CCBS - DK/DC/HUY NGUONG CN ------------ 
    -- Nghiem thu
    -- theo thue bao
    -- ?K l?n cu?i cùng trong 1 tháng
    -- Lo?i tr? HMM VNP CHUA vì không có trong danh m?c Nghi?p v?
    */
    insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        with tbl as(    select nv.thang, ma_tb, MA_KH, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
                                        , row_number() over(partition by ma_tb, a.MANV_RA_PCT order by a.ngay_cn desc) rnk
                                        , nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
                        from tuyenngo.sbh_vnp_202501_ct a
                                            join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
                        where TEN_LOAIHD = 'DK/DC/HUY NGUONG CN' and MANV_RA_PCT is not null --and ma_kh = '010030778'
                    )
        select ma_tb, MA_KH, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
                    , THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
        from tbl
        where rnk = 1
        ;
			
/* ----HauMai-Muc 6----------- CCBS - DOI SIM ------------ 
    -- Nghiem thu
    -- theo MAKH, c?p nh?t ??u tiên
    --100 nghiep vu trong ngay/KH
    -- thieu thong tin MA_KH, doi tuong KH de xu ly tren cung 1 KH de loc 100 nghiep vu
    -- loai tru trung cua CCBS - DOI SIM
    delete from ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd = 'DOI SIM' and thang = 202501;
    */
    insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, DOITUONG_ID, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        with tbl as(select nv.thang, ma_tb, MA_KH, DOITUONG_ID, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
                                        , row_number() over(partition by ma_tb, a.MANV_RA_PCT order by a.ngay_cn) rnk
                                        , nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
                            from tuyenngo.sbh_vnp_202501_ct a
                                            join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
                            where TEN_LOAIHD = 'DOI SIM' and MANV_RA_PCT is not null and nvl(doituong_id, 1) in (1, 25)
                            )
        select ma_tb, MA_KH, DOITUONG_ID, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
                    , THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
        from tbl
        where rnk = 1
    ;
    commit ;
    insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, DOITUONG_ID, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
        with tbl as(select nv.thang, ma_tb, MA_KH, DOITUONG_ID, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
                                        , nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
                                        , row_number() over(partition by MA_KH, ma_tb, a.MANV_RA_PCT order by a.ngay_cn) rnk
                            from tuyenngo.sbh_vnp_202501_ct a
                                            join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
                            where TEN_LOAIHD = 'DOI SIM' and MANV_RA_PCT is not null and nvl(doituong_id, 1) not in (1, 25)
                            )
        select ma_tb, MA_KH, DOITUONG_ID, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
                    , THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
        from tbl
        where rnk = 1
    ;
			
/* -----HauMai-Muc 11---------- CCBS - DONG MO DV|0 ------------ 
-- Nghiem thu
-- theo MAKH, cập nhật ưu tiên
-- 100 nghiep vu trong ngay/KH
-- thieu thong tin MA_KH, doi tuong KH de xu ly tren cung 1 KH de loc 100 nghiep vu
delete from ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd = 'DONG MO DV|0' and thang = 202501;
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, doituong_id, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB)
		with tbl as(    select nv.thang, ma_tb, MA_KH, doituong_id, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
										, row_number() over(partition by MA_KH, a.MANV_RA_PCT order by a.ngay_cn) rnk
										, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
						from tuyenngo.sbh_vnp_202501_ct a
							join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
						where TEN_LOAIHD = 'DONG MO DV|0' and MANV_RA_PCT is not null and nvl(doituong_id, 1) in (1, 25)
					)
		select MA_TB, MA_KH, doituong_id, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
				, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
		from tbl
		where rnk = 1
	;
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, doituong_id, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tbl as(    select nv.thang, ma_tb, MA_KH, doituong_id, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
							   , row_number() over(partition by MA_KH, ma_tb, a.MANV_RA_PCT order by a.ngay_cn) rnk
							   , nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
						from tuyenngo.sbh_vnp_202501_ct a
							join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
						where TEN_LOAIHD = 'DONG MO DV|0' and MANV_RA_PCT is not null and nvl(doituong_id, 1) not in (1, 25)
					)
		select MA_TB, MA_KH, doituong_id, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
			   , THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
		from tbl
		where rnk = 1
	;
            
/* ----HauMai-Muc 12----------- CCBS - DONG MO DV|1 ------------ 
-- Nghiem thu
-- theo MAKH, c?p nh?t ??u tiên
--100 nghiep vu trong ngay/KH
-- thieu thông tin MA_KH, doi tuong KH ?? x? lý trên cùng 1 KH de l?c 100 nghi?p v?
delete from ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd = 'DONG MO DV|1' and thang = 202501;
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, doituong_id, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB)
		with tbl as(select nv.thang, ma_tb, MA_KH, doituong_id, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
										, row_number() over(partition by MA_KH, a.MANV_RA_PCT order by a.ngay_cn) rnk
										, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
							from tuyenngo.sbh_vnp_202501_ct a
											join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
							where TEN_LOAIHD = 'DONG MO DV|1' and MANV_RA_PCT is not null and nvl(doituong_id, 1) in (1, 25)
							)
		select MA_TB, MA_KH, doituong_id, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
					, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
		from tbl
		where rnk = 1
	;
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, doituong_id, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB)
		with tbl as(select nv.thang, ma_tb, MA_KH, doituong_id, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
										, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
										, row_number() over(partition by MA_KH, ma_tb, a.MANV_RA_PCT order by a.ngay_cn) rnk
							from tuyenngo.sbh_vnp_202501_ct a
											join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
							where TEN_LOAIHD = 'DONG MO DV|1' and MANV_RA_PCT is not null and nvl(doituong_id, 1) not in (1, 25)
							)
		select MA_TB, MA_KH, doituong_id, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
					, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
		from tbl
		where rnk = 1
	;
	commit;

/* -----HauMai-Muc 13---------- CCBS - DONG TRUOC GOI CUOC ------------ 
-- Nghiem thu
-- theo MAKH, c?p nh?t ?âu tiên
-- 100 nghiep vu trong ngay/KH
-- thieu thông tin MA_KH, doi tuong KH ?? x? lý trên cùng 1 KH de l?c 100 nghi?p v?
delete from ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd = 'DONG TRUOC GOI CUOC' and thang = 202501;
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, doituong_id, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB)
		with tbl as(    select nv.thang, ma_tb, MA_KH, doituong_id, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
										, row_number() over(partition by MA_KH, a.MANV_RA_PCT order by a.ngay_cn) rnk
										, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
						from tuyenngo.sbh_vnp_202501_ct a
							join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
						where TEN_LOAIHD = 'DONG TRUOC GOI CUOC' and MANV_RA_PCT is not null and nvl(doituong_id, 1) in (1, 25)
					)
		select ma_tb, MA_KH, doituong_id, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
					, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB
		from tbl
		where rnk = 1
	;
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, doituong_id, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB)
		with tbl as(    select nv.thang, ma_tb, MA_KH, doituong_id, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
								, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
								, row_number() over(partition by MA_KH, ma_tb, a.MANV_RA_PCT order by a.ngay_cn) rnk
						from tuyenngo.sbh_vnp_202501_ct a
							join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
						where TEN_LOAIHD = 'DONG TRUOC GOI CUOC' and MANV_RA_PCT is not null and nvl(doituong_id, 1) not in (1, 25)
					)
		select ma_tb, MA_KH, doituong_id, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
					, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB
		from tbl
		where rnk = 1
	;
    commit;			
/* -----HauMai-Muc 14---------- CCBS - THANH LY/PTOC ------------ 
-- Nghiem thu
-- theo thue bao
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tbl as(select nv.thang, ma_tb, MA_KH, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
										, row_number() over(partition by ma_tb, a.MANV_RA_PCT order by a.ngay_cn) rnk
										, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
							from tuyenngo.sbh_vnp_202501_ct a
											join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
							where TEN_LOAIHD = 'THANH LY/PTOC' and MANV_RA_PCT is not null --and ma_kh = '010030778'
							)
		select ma_tb, MA_KH, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
					, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
		from tbl
		where rnk = 1
	;
/* ------HauMai-Muc 25--------- CCBS - THU CUOC ------------ 
-- Nghiem thu
-- theo MAKH
-- Loai tr? trùng các nghiep v? khác CCBS
*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tbl as(select nv.thang, ma_tb, MA_KH, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
										, row_number() over(partition by MA_KH, a.MANV_RA_PCT order by a.ngay_cn) rnk
										, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
							from tuyenngo.sbh_vnp_202501_ct a
											join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
							where TEN_LOAIHD = 'THU CUOC' and MANV_RA_PCT is not null --and ma_kh = '010030778'
							)
		select ma_tb, MA_KH, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
					, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
		from tbl
		where rnk = 1
	;
/* ----HauMai-Muc 26----------- CCBS - THU VUOTNGUONG/TAMTHU CN/THUHO ------------ 
    -- Nghiem thu
    -- theo MAKH
    -- Loai tr? trùng các nghiep v? khác CCBS
    */
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tbl as(select nv.thang, ma_tb, MA_KH, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
										, row_number() over(partition by MA_KH, a.MANV_RA_PCT order by a.ngay_cn) rnk
										, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
							from tuyenngo.sbh_vnp_202501_ct a
											join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
							where TEN_LOAIHD = 'THU VUOTNGUONG/TAMTHU CN/THUHO' and MANV_RA_PCT is not null --and ma_kh = '010030778'
							)
		select ma_tb, MA_KH, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
					, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
		from tbl
		where rnk = 1
	;
			
/* -----HauMai-Muc 5---------- CCBS - CHUYEN QUYEN CCBS ------------ 
    -- Nghiem thu
    -- theo thue bao
    */
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		with tbl as(select nv.thang, ma_tb, MA_KH, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
										, row_number() over(partition by ma_tb, a.MANV_RA_PCT order by a.ngay_cn) rnk
										, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
							from tuyenngo.sbh_vnp_202501_ct a
											join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202501
							where TEN_LOAIHD = 'CHUYEN QUYEN' and MANV_RA_PCT is not null --and ma_kh = '010030778'
							)
		select ma_tb, MA_KH, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
					, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
		from tbl
		where rnk = 1
	;
	commit ;
----------------------------------------------------------------------------------------------------
    --loai trừ các đơn vị khác
    delete from ttkd_bsc.ct_bsc_nghiepvu where donvi = 'VTTP';
	
    --loại trừ trùng BAN THIET BI vs Nghiệp vụ LAPDATMOI
    delete from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'BAN THIET BI' and 'ONEBSS' = loai and a.thang = 202501
                and exists (select 1 from ttkd_bsc.ct_bsc_nghiepvu where TEN_LOAIHD = 'LAP DAT MOI' and 'ONEBSS' = loai and thuebao_id = a.thuebao_id and thang = a.thang)
                ;
    --loại trừ trùng TAO MOI GOI DA DICH VU vs Nghiep vụ LAPDATMOI
    delete from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'TAO MOI GOI DA DICH VU' and 'ONEBSS' = loai and a.thang = 202501
                and exists (select 1 from ttkd_bsc.ct_bsc_nghiepvu where TEN_LOAIHD = 'LAP DAT MOI' and 'ONEBSS' = loai and thuebao_id = a.thuebao_id and thang = a.thang)
                ;
    --loại trừ trùng ONEBSS - THUKHAC so voi ONEBSS - Nghiep vu khac
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'THU KHAC' and 'ONEBSS' = loai and a.thang = 202501
                and exists (select 1 from ttkd_bsc.ct_bsc_nghiepvu where TEN_LOAIHD != 'THU KHAC' and 'ONEBSS' = loai and ma_kh = a.ma_kh and thang = a.thang)
    ;
    --loại trừ trùng ONEBSS - THU CUOC so voi ONEBSS - Nghiep vu khac
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'THU CUOC' and 'ONEBSS' = loai and a.thang = 202501
                and exists (select 1 from ttkd_bsc.ct_bsc_nghiepvu where TEN_LOAIHD != 'THU CUOC' and 'ONEBSS' = loai and ma_kh = a.ma_kh and thang = a.thang)
    ;
    --loại trừ trùng USSD - DOSIM trong CCBS - DOISIM
    delete from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'DOI SIM' and 'USSD' = loai and a.thang = 202501
                and exists (select 1 from ttkd_bsc.ct_bsc_nghiepvu where TEN_LOAIHD = 'DOI SIM' and 'CCBS' = loai and ma_tb = a.ma_tb and thang = a.thang)
    ;
    --loại trừ trùng CCBS - CNTTTB voi CCBS - CAP NHAT DB
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'CNTTTB' and 'CCBS' = loai and a.thang = 202501
                and exists (select * from  tuyenngo.sbh_vnp_202501_ct where ten_loaihd = 'CAP NHAT DB' and a.thang = thang and ma_tb = a.ma_tb)
    ;
    --loại trừ trùng ONEBSS - THAYDOITHONGTIN-GIAHANDICHVUCNTT voi ONEBSS - LAPDATMOI
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'THAY DOI THONG TIN - GIA HAN DICH VU CNTT' and 'ONEBSS' = loai and a.thang = 202501
                and exists (select * from  ttkd_bsc.ct_bsc_nghiepvu
                                    where ten_loaihd = 'LAP DAT MOI' and 'ONEBSS' = loai and ma_tb = a.ma_tb and thang = a.thang)
    ;
    --loại trừ trùng ONEBSS - THAYDOITOCDO ADSL, TSL voi ONEBSS - LAPDATMOI
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'THAY DOI TOC DO INTERNET' and 'ONEBSS' = loai and a.thang = 202501
                and exists (select * from  ttkd_bsc.ct_bsc_nghiepvu
                                    where ten_loaihd = 'LAP DAT MOI' and 'ONEBSS' = loai and ma_tb = a.ma_tb and thang = a.thang)
    ;
    --loại trừ trùng ONEBSS - TIEP NHAN KHAO SAT DAT MOI voi ONEBSS - LAPDATMOI
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'TIEP NHAN KHAO SAT DAT MOI' and 'ONEBSS' = loai and a.thang = 202501
                and exists (select * from  ttkd_bsc.ct_bsc_nghiepvu
                                    where ten_loaihd = 'LAP DAT MOI' and 'ONEBSS' = loai and ma_kh = a.ma_kh and thang = a.thang)
    ;
    
    --loại trừ trùng ONEBSS - TIEP NHAN LAP DAT MOI voi ONEBSS - LAPDATMOI
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'TIEP NHAN LAP DAT MOI' and 'ONEBSS' = loai and a.thang = 202501
                and exists (select * from  ttkd_bsc.ct_bsc_nghiepvu
                                    where ten_loaihd = 'LAP DAT MOI' and 'ONEBSS' = loai and ma_kh = a.ma_kh and thang = a.thang)
    ;
	
    --loại trừ trùng ONEBSS - THAY DOI DAT COC voi ONEBSS - NGHIEPVUKHAC
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'THAY DOI DAT COC' and 'ONEBSS' = loai and a.thang = 202501
                and exists (select distinct TEN_LOAIHD, loai from  ttkd_bsc.ct_bsc_nghiepvu
                                    where ten_loaihd != 'THAY DOI DAT COC' and 'ONEBSS' = loai and ma_tb = a.ma_tb and thang = a.thang)
    ;
	
	/* ----- Nghiệp vụ không ghi nhận ----- */
    --loại trừ trùng ONEBSS - KY LAI HOP DONG GOC voi ONEBSS - NGHIEPVUKHAC
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'KY LAI HOP DONG GOC' and 'ONEBSS' = loai and a.thang = 202501
                and exists (select distinct TEN_LOAIHD, loai from  ttkd_bsc.ct_bsc_nghiepvu
                                    where ten_loaihd != 'KY LAI HOP DONG GOC' and 'ONEBSS' = loai and ma_tb = a.ma_tb and thang = a.thang)
    ;
    --loại trừ trùng ONEBSS - THAY THE/THU HOI/CAP BO SUNG VAT TU voi ONEBSS - NGHIEPVUKHAC
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'THAY THE/THU HOI/CAP BO SUNG VAT TU' and 'ONEBSS' = loai and a.thang = 202501
                and exists (select distinct TEN_LOAIHD, loai from  ttkd_bsc.ct_bsc_nghiepvu
                                    where ten_loaihd != 'THAY THE/THU HOI/CAP BO SUNG VAT TU' and 'ONEBSS' = loai and ma_tb = a.ma_tb and thang = a.thang)
    ;
    --loại trừ trùng ONEBSS - DAT COC MOI voi ONEBSS - LAPDATMOI
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'DAT COC MOI' and 'ONEBSS' = loai and a.thang = 202501
                and exists (select * from  ttkd_bsc.ct_bsc_nghiepvu
                                    where ten_loaihd = 'LAP DAT MOI' and 'ONEBSS' = loai and ma_kh = a.ma_kh and thang = a.thang)
    ;
	
    --loại trừ trùng ONEBSS - TACH NHAP THUE BAO voi ONEBSS - THAY DOI THONG TIN - GIA HAN DICH VU CNTT
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'TACH NHAP THUE BAO' and 'ONEBSS' = loai and a.thang = 202501
                and exists (select * from  ttkd_bsc.ct_bsc_nghiepvu
                                    where ten_loaihd = 'THAY DOI THONG TIN - GIA HAN DICH VU CNTT' and 'ONEBSS' = loai and ma_kh = a.ma_kh and thang = a.thang)
    ;
	
    --loại trừ trùng CCBS - THUCUOC voi CCBS - NGHIEP VU KHAC
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'THU CUOC' and loai = 'CCBS' and a.thang = 202501
                and exists (select * from  ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd != 'THU CUOC' and loai = 'CCBS' and a.thang = thang and ma_tb = a.ma_tb)
    ;
    
    --loại trừ trùng CCBS - THU VUOTNGUONG/TAMTHU CN/THUHO voi CCBS - NGHIEP VU KHAC
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'THU VUOTNGUONG/TAMTHU CN/THUHO' and 'CCBS' = loai and a.thang = 202501
                and exists (select 1 from  ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd != 'THU VUOTNGUONG/TAMTHU CN/THUHO' and 'CCBS' = loai and a.thang = thang and ma_tb = a.ma_tb)
    ;
    
    --loại trừ trùng CCBS - DONG MO DV|0 voi CCBS - NGHIEP VU KHAC
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'DONG MO DV|0' and 'CCBS' = loai and a.thang = 202501
                and exists (select 1 from  ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd != 'DONG MO DV|0' and 'CCBS' = loai and a.thang = thang and ma_tb = a.ma_tb)
    ;
    --loại trừ trùng CCBS - DONG MO DV|0 voi CCBS - NGHIEP VU KHAC
    delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
            where TEN_LOAIHD = 'DONG MO DV|1' and 'CCBS' = loai and a.thang = 202501
                and exists (select 1 from  ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd != 'DONG MO DV|1' and 'CCBS' = loai and a.thang = thang and ma_tb = a.ma_tb)
    ;
commit;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from ttkd_bct.cuoc_thuebao_ttkd where loaitb_id = 149;
select ma_tt, ma_tb from ttkd_bct.cuoc_thuebao_ttkd where loaitb_id = 149 Group by ma_tt, ma_tb having count(*)>1;
--
select a.* from ttkd_bsc.ct_bsc_nghiepvu a where a.thang = 202501 and a.donvi = 'TTKD';
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- xuat du lieu theo yeu cau chi Trang tren group (chup hinh luu ngay 18/02/2025)
--- 1. file chi tiet theo dm nghiep vu cua hang
--- 2. có phan loại DANHMUC
--- 3. đối với CH bỏ vụ tính gom 100
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
with tmp_nvch as (
	select a.THANG, a.LOAI, a.TEN_LOAIHD, a.MA_NV, a.NGAY_DKY_VI, a.MA_TB, a.MA_KH 
	From ttkd_bsc.ct_bsc_nghiepvu a
	Where a.thang = 202501 and trim(a.donvi) = 'TTKD'
          and trim(a.LOAI) in ('ONEBSS','CCBS','CCOS')
		  and trim(a.TEN_TO) like 'Cửa%'
	Order by a.LOAI, a.TEN_LOAIHD
)
--=== HỆ SỐ QUY ĐỔI THEO ANH NGUYÊN ĐÃ CHỐT VỚI CHỊ TRANG XÃ
, tmp_qd as (
	--=== 1:1
	select loai, ten_loaihd, ma_nv, 1 sanluong, 1 quydoi
    from tmp_nvch
    where thang = 202501
		  and ten_loaihd not in ('DK/DC/HUY NGUONG CN','DONG MO DV|0','DONG MO DV|1','THU CUOC','THAY DOI DICH VU','THU KHAC','BIEN DONG KHAC')

    --=== CH gom 2 nghiệp vụ DONG MO DV|0, DONG MO DV|1 của cùng thuê bao trong ngày để tính quy đổi
    Union all
    select loai, ten_loaihd, ma_nv, sanluong, 1 quydoi															-- 
		   --, floor( count(ma_nv)/100)+case when mod(count(ma_nv),100)>0 then 1 else 0 end quydoi		-- CH không làm sĩ lên không chạy đoạn 100
    from (
            select loai, 'DONG MO DV|0|1'ten_loaihd, ma_nv, ma_kh, ma_tb, to_char(NGAY_DKY_VI,'dd/mm/yyyy')NGAY_DKY_VI, sum(sanluong)sanluong
            From (
                    select loai, ten_loaihd, ma_nv, ma_kh, ma_tb, NGAY_DKY_VI, 1 sanluong
                    from tmp_nvch
                    where thang = 202501 and ten_loaihd in ('DONG MO DV|0','DONG MO DV|1')
                 )
            Group by loai, ma_nv, ma_kh, ma_tb, NGAY_DKY_VI
         )
    group by loai, ten_loaihd, ma_nv, sanluong
	
	--=== ĐẾM 1 LẦN TRONG THÁNG
    Union all
    select loai, ten_loaihd, ma_nv, sum(sanluong)sanluong, 1 quydoi
    from (
            select distinct loai, ten_loaihd, ma_nv, ma_kh, ma_tb, 1 sanluong
            from tmp_nvch
            where thang = 202501 and ten_loaihd in ('DK/DC/HUY NGUONG CN','THAY DOI DICH VU')
         )
    group by loai, ten_loaihd, ma_nv, ma_kh
	
    --=== THU CUOC THU KHAC theo 0.25*ma_kh
    Union all
    select loai, ten_loaihd, ma_nv, count(ma_kh)sanluong, count(distinct ma_kh)*0.25 quydoi
    from tmp_nvch
    where thang = 202501 and ten_loaihd in ('THU KHAC', 'THU CUOC')
    group by loai, ten_loaihd, ma_nv
	
	--=== BIEN DONG KHAC theo ma_tb
    Union all
    select loai, ten_loaihd, ma_nv, count(ma_tb)sanluong, count(distinct ma_tb)quydoi
    from tmp_nvch
    where thang=202501 and ten_loaihd='BIEN DONG KHAC'
    group by loai, ten_loaihd, ma_nv
)
--=== LAY THEO sheet DM NGHIEP VU (CH)
Select a.LOAI, a.TEN_LOAIHD, nv.MA_PB, nv.TEN_PB, nv.MA_TO, nv.TEN_TO, a.MA_NV, nv.TEN_NV, nv.TEN_VTCV
       , sum(sanluong)sanluong, sum(quydoi)quydoi 
       , case when trim(TEN_LOAIHD) in ('KHIEU NAI - HOAN THANH', 'BIEN DONG KHAC', 'TIEP NHAN KHAO SAT DAT MOI', 'TIEP NHAN LAP DAT MOI'
                                         , 'CHUYEN DOI LOAI HINH THUE BAO', 'TAO MOI GOI DA DICH VU', 'THAY DOI GOI DA DICH VU') and loai = 'ONEBSS' then 'DM_KHOAN'
              when trim(TEN_LOAIHD) in ('CAP NHAT DB') and loai = 'CCBS' then 'DM_KHOAN'
              when trim(TEN_LOAIHD) in ('KHIEU NAI - DA XU LY') and loai = 'CCOS' then 'DM_KHOAN'
              when trim(TEN_LOAIHD) in ('LAP DAT MOI - CNTT', 'LAP DAT MOI - CNTTQLDA', 'LAP DAT MOI - BRCD', 'BAN THIET BI') and loai = 'ONEBSS' then 'DM_PTM'
              when trim(TEN_LOAIHD) in ('HMM TRA SAU') and loai = 'CCBS' then 'DM_PTM'
         else 'DM_HAUMAI' end DANHMUC
From tmp_qd a
    Join ttkd_bsc.nhanvien nv on a.ma_nv = nv.ma_nv and nv.thang = 202501
Where trim(a.TEN_LOAIHD) in 
			( -- ONEBSS
			'BAN THIET BI', 'CHAM DUT SU DUNG', 'CHUYEN QUYEN', 'DICH CHUYEN', 'DOI SO/ACCOUNT', 'KHIEU NAI - TIEPNHAN'
			, 'TACH NHAP THUE BAO', 'THAY DOI DICH VU', 'THAY DOI THONG SO IMS', 'THAY DOI THONG SO MEGAWAN'
			, 'THAY DOI THONG TIN - GIA HAN DICH VU CNTT', 'THAY DOI TOC DO INTERNET', 'THU CUOC', 'THU KHAC'
			-- CCBS
			, 'CHUYEN QUYEN','CNTTTB', 'DANG KY HUY CHUYEN DOI GOI CUOC', 'DK NHOM DAI DIEN HUONG CUOC'
			, 'DK/DC/HUY NGUONG CN', 'DOI SIM', 'DONG MO DV|0', 'DONG MO DV|1', 'DONG TRUOC GOI CUOC'
			, 'THANH LY/PTOC', 'THU CUOC', 'THU VUOTNGUONG/TAMTHU CN/THUHO'
			-- CCOS
			,'KHIEU NAI - TIEP NHAN'
			)
Group by a.LOAI, a.TEN_LOAIHD, nv.MA_PB, nv.TEN_PB, nv.MA_TO, nv.TEN_TO, a.MA_NV, nv.TEN_NV, nv.TEN_VTCV
Order by a.loai, a.ten_loaihd
;
--=== LAY THEO sheet DM NGHIEP VU_KHOAN
Select a.LOAI, a.TEN_LOAIHD, nv.MA_PB, nv.TEN_PB, nv.MA_TO, nv.TEN_TO, a.MA_NV, nv.TEN_NV, nv.TEN_VTCV
       , sum(sanluong)sanluong, sum(quydoi)quydoi
       , case when trim(TEN_LOAIHD) in ('KHIEU NAI - HOAN THANH', 'BIEN DONG KHAC', 'TIEP NHAN KHAO SAT DAT MOI', 'TIEP NHAN LAP DAT MOI'
                                         , 'CHUYEN DOI LOAI HINH THUE BAO', 'TAO MOI GOI DA DICH VU', 'THAY DOI GOI DA DICH VU') and loai = 'ONEBSS' then 'DM_KHOAN'
              when trim(TEN_LOAIHD) in ('CAP NHAT DB') and loai = 'CCBS' then 'DM_KHOAN'
              when trim(TEN_LOAIHD) in ('KHIEU NAI - DA XU LY') and loai = 'CCOS' then 'DM_KHOAN'
              when trim(TEN_LOAIHD) in ('LAP DAT MOI - CNTT', 'LAP DAT MOI - CNTTQLDA', 'LAP DAT MOI - BRCD', 'BAN THIET BI') and loai = 'ONEBSS' then 'DM_PTM'
              when trim(TEN_LOAIHD) in ('HMM TRA SAU') and loai = 'CCBS' then 'DM_PTM'
         else 'DM_HAUMAI' end DANHMUC
From tmp_qd a
    Join ttkd_bsc.nhanvien nv on a.ma_nv = nv.ma_nv and nv.thang = 202501
Where a.LOAI='ONEBSS' and trim(a.TEN_LOAIHD) in ( 'KHIEU NAI - HOAN THANH', 'BIEN DONG KHAC', 'TIEP NHAN KHAO SAT DAT MOI', 'TIEP NHAN LAP DAT MOI'
                                                  , 'CHUYEN DOI LOAI HINH THUE BAO', 'TAO MOI GOI DA DICH VU', 'THAY DOI GOI DA DICH VU' )
      Or ( a.LOAI='CCBS' and trim(a.TEN_LOAIHD) in ('CAP NHAT DB') )
      Or ( a.LOAI='CCOS' and trim(a.TEN_LOAIHD) in ('KHIEU NAI - DA XU LY') )

Group by a.LOAI, a.TEN_LOAIHD, nv.MA_PB, nv.TEN_PB, nv.MA_TO, nv.TEN_TO, a.MA_NV, nv.TEN_NV, nv.TEN_VTCV
Order by a.loai, a.ten_loaihd
;
--=== LAY THEO sheet DM NGHIEP VU KHÔNG GHI NHẬN - ONBESS
Select a.LOAI, a.TEN_LOAIHD, nv.MA_PB, nv.TEN_PB, nv.MA_TO, nv.TEN_TO, a.MA_NV, nv.TEN_NV, nv.TEN_VTCV
       , sum(sanluong)sanluong, sum(quydoi)quydoi
       , case when trim(TEN_LOAIHD) in ('KHIEU NAI - HOAN THANH', 'BIEN DONG KHAC', 'TIEP NHAN KHAO SAT DAT MOI', 'TIEP NHAN LAP DAT MOI'
                                         , 'CHUYEN DOI LOAI HINH THUE BAO', 'TAO MOI GOI DA DICH VU', 'THAY DOI GOI DA DICH VU') and loai = 'ONEBSS' then 'DM_KHOAN'
              when trim(TEN_LOAIHD) in ('CAP NHAT DB') and loai = 'CCBS' then 'DM_KHOAN'
              when trim(TEN_LOAIHD) in ('KHIEU NAI - DA XU LY') and loai = 'CCOS' then 'DM_KHOAN'
              when trim(TEN_LOAIHD) in ('LAP DAT MOI - CNTT', 'LAP DAT MOI - CNTTQLDA', 'LAP DAT MOI - BRCD', 'BAN THIET BI') and loai = 'ONEBSS' then 'DM_PTM'
              when trim(TEN_LOAIHD) in ('HMM TRA SAU') and loai = 'CCBS' then 'DM_PTM'
			  when trim(TEN_LOAIHD) in ( 'KY LAI HOP DONG GOC','THAY THE/THU HOI/CAP BO SUNG VAT TU','DAT COC MOI','THAY DOI DAT COC' ) and loai = 'ONEBSS' then 'DM_KHONGGHI'
         else 'DM_HAUMAI' end DANHMUC
From tmp_qd a
    Join ttkd_bsc.nhanvien nv on a.ma_nv = nv.ma_nv and nv.thang = 202501
Where a.LOAI='ONEBSS' and trim(a.TEN_LOAIHD) in ( 'KY LAI HOP DONG GOC','THAY THE/THU HOI/CAP BO SUNG VAT TU','DAT COC MOI','THAY DOI DAT COC' )
Group by a.LOAI, a.TEN_LOAIHD, nv.MA_PB, nv.TEN_PB, nv.MA_TO, nv.TEN_TO, a.MA_NV, nv.TEN_NV, nv.TEN_VTCV
Order by a.loai, a.ten_loaihd
;


--select a.*, b.heso, a.SANLUONG * b.HESO sanluong_heso from tbl1 a
--left join hocnq_ttkd.nghiepvu_heso b on a.loai = b.loai and a.ten_loaihd = b.ten_loaihd;

select * from hocnq_ttkd.nghiepvu_heso;
/*
select * from hocnq_ttkd.nghiepvu_heso;
create table hocnq_ttkd.nghiepvu_heso as
select distinct LOAI, TEN_LOAIHD, cast(null as number) heso from ttkd_bsc.ct_bsc_nghiepvu where thang = 202501;
	select * from ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd = 'DONG MO DV|0' and thang = 202501;
select * from tuyenngo.sbh_vnp_202501_ct a;
select distinct LOAI_CN from tuyenngo.solieu_ccbs a;
select distinct ten_loaihd from tuyenngo.sbh_202501_CT a;
select * from tuyenngo.sbh_ct_thu_202501_ct a where manv_ra_pct is not null;
*/