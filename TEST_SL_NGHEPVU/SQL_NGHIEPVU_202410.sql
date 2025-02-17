------Gom dư liệu các nguồn-----------
/* ------------------- UPDATE VINAGIFT ------------------- */
-- web http://10.70.115.121/ -> tang qua -> bao cao voucher

select * from SBH_vinagift_202410_CT where manv_cn in('790627','790272') ;
select distinct manv_cn,nhanvien_cn from SBH_vinagift_202410_CT where manv_hrm is null ;

update SBH_vinagift_202410_CT set manv_hrm=upper(manv_cn) where manv_cn in('CTV053229','ctv041285') ;
commit ;
update SBH_vinagift_202410_CT set manv_cn=upper(manv_cn) ;

update SBH_vinagift_202410_CT set manv_cn='000'||manv_cn where length(trim(manv_cn))=2 ;
update SBH_vinagift_202410_CT set manv_cn='00'||manv_cn where length(trim(manv_cn))=3 ;
update SBH_vinagift_202410_CT set manv_cn='0'||manv_cn where length(trim(manv_cn))=4 ;

update SBH_vinagift_202410_CT a set a.manv_hrm=(select manv_hrm from ttkd_bsc.nhanvien where ma_nv=upper(manv_cn) and thang=202410)
where a.manv_hrm is null ;

commit ;


update SBH_vinagift_202410_CT a set (a.ten_nv,a.ma_vtcv,a.ten_vtcv,a.ma_to,a.ten_to,a.ma_pb,a.ten_pb)
                    =(select ten_nv,ma_vtcv,ten_vtcv,ma_to,ten_to,ma_pb,ten_pb 
                      from ttkd_bsc.nhanvien where manv_hrm=a.manv_hrm and thang=202410) where a.manv_hrm is not null ;
commit ;
select distinct manv_cn,nhanvien_cn from SBH_vinagift_202410_CT where manv_hrm is null ;

select * from SBH_vinagift_202410_CT where manv_hrm is null ;
      select so_seri ma_tb,NULL ma_gd, NULL ma_kh,manv_hrm manv_ra_pct,ten_nv tennv_ra_pct,ma_to mato_ra_pct,ten_to tento_ra_pct,ma_pb mapb_ra_pct,ten_pb tenpb_ra_pct,
             ma_vtcv, to_date('01/10/2024 00:00','dd/mm/yyyy hh24:mi')ngay_cn, 0 tg_damthoai, 'VINAGIFT' TEN_LOAIHD,'VINAGIFT' loai 
             from SBH_VINAGIFT_202410_CT 

/* ------------------ UPDATE USSD ------------------- */

/* SMRS vao mail tap doan, VAO  PHAN TICH -> NHOM BAO CAO DOI SIM 4G -> BC CHI TIET DOI SIM 4G - hh24:mi:ss */

select * from SBH_ussd_202410_CT where manv_hrm is null and ccbs_user is not null ;
select * from SBH_ussd_202410_CT 
where ccbs_user in('huongntt_hcm','lanntp_hcm','linhntk_hcm','ngadt_hcm','nganbtb_hcm','nghihlp_hcm','ngocnhy_hcm','ngocpla_hcm','nhanhvt_hcm','nhitt_hcm','oanhvtt_hcm','phuongnth1_hcm','qlc_khoamo_hcm','thampt_hcm','thuptm1_hcm','thuyhtt_hcm','tientt_hcm','trangptm_hcm','ttvt_tronght_hcm','vanntth_hcm') ;

--update SBH_ussd_202410_CT set manv_cn=upper(manv_cn) ;

update SBH_ussd_202410_CT a set a.manv_hrm=ma_ctv where ma_ctv is not null ;
commit ;

update SBH_ussd_202410_CT a set a.manv_hrm=(select ma_nv from ttkd_bsc.nhanvien where thang = 202410 and user_ccbs=a.ccbs_user)
where a.manv_hrm is null ;
commit ;

update SBH_ussd_202410_CT a set (a.ten_nv,a.ma_vtcv,a.ten_vtcv,a.ma_to,a.ten_to,a.ma_pb,a.ten_pb)
                    =(select ten_nv,ma_vtcv,ten_vtcv,ma_to,ten_to,ma_pb,ten_pb 
                      from ttkd_bsc.nhanvien where ma_nv=a.manv_hrm  and thang=202410) where a.manv_hrm is not null ;
commit ;

select distinct ccbs_user from SBH_ussd_202410_CT where manv_hrm is null ;

      select so_thue_bao ma_tb,NULL ma_gd, NULL ma_kh, manv_hrm manv_ra_pct, ten_nv tennv_ra_pct, ma_to mato_ra_pct, ten_to tento_ra_pct, ma_pb mapb_ra_pct,ten_pb tenpb_ra_pct,
             ma_vtcv, to_date(THOI_GIAN_DOI,'dd/mm/yyyy hh24:mi:ss')ngay_cn, 0 tg_damthoai, 'DOI SIM' TEN_LOAIHD,'USSD' loai 
      from SBH_USSD_202410_CT 
;
--user_ccbs in ('ctv029090_hcm','ctv070850_hcm','ctv080957_hcm','ctv_giatbtmi_hcm','ctv_hoanth_hcm','ctv_nhannt01_hcm','ctv_nhutnm88_hcm','ctv_uyentlt_hcm')
/* ---------------------------- CCOS -------------------------------- */

/* user CCOS : tuyenn_hcm_vnp2/123456aA@    link  ccos.vnpt.vn  vao GQKN -> bao cao thong ke -> bao cao tong hop VTT -> vao sl tiep nhan - sl da xu ly */

update SBH_ccos_202410_CT set ma_tb='84'||trim(ma_tb);
commit ;

update SBH_CCOS_202410_CT a set (a.manv_hrm,a.ten_nv,a.ma_vtcv,a.ten_vtcv,a.ma_to,a.ten_to,a.ma_pb,a.ten_pb)
                    =(select manv_hrm,ten_nv,ma_vtcv,ten_vtcv,ma_to,ten_to,ma_pb,ten_pb 
                      from ttkd_bsc.nhanvien where user_ccos=a.user_ccos and thang=202410) ;
commit ;

select * from SBH_CCOS_202410_CT where manv_hrm is null ;


      select ma_tb,NULL ma_gd, NULL ma_kh,manv_hrm manv_ra_pct,ten_nv tennv_ra_pct,ma_to mato_ra_pct,ten_to tento_ra_pct,ma_pb mapb_ra_pct,ten_pb tenpb_ra_pct,
             ma_vtcv, to_date(ngay_th,'dd/mm/yyyy hh24:mi')ngay_cn, 0 tg_damthoai, upper(bo_dau(TEN_LOAIHD))TEN_LOAIHD,'CCOS' loai 
             from SBH_CCOS_202410_CT 

/* ------------------------------------------------------------------ */

/* NV */
--select * from SBH_202410_CT ;
--drop table SBH_202410_CT ;
drop table a_sbh_temp purge ;
create table a_sbh_temp as
      select to_char(trunc(hdkh.ngay_yc),'yyyymm') thang, hdtb.hdtb_id, hdkh.hdkh_id, hdkh.ma_gd, hdkh.ma_hd, hdkh.ma_kh, hdtb.ma_tb, hdkh.ngay_yc, hdkh.ctv_id, hdkh.nhanvien_id, 
             hdkh.nguoi_cn, hdkh.loaihd_id, (SELECT lhd.ten_loaihd FROM css.loai_hd@dataguard lhd WHERE hdkh.loaihd_id=lhd.loaihd_id) TEN_LOAIHD, 
             hdkh.ngaylap_hd, hdtb.tthd_id, (SELECT tthd.trangthai_hd FROM css.trangthai_hd@dataguard tthd WHERE hdtb.tthd_id=tthd.tthd_id) TRANGTHAI_HD,
             hdtb.KIEULD_ID, (select ten_kieuld from css.kieu_ld@dataguard where kieuld_id = hdtb.kieuld_id)ten_kieuld,
             hdkh.khachhang_id, hdkh.ma_duan, hdtb.thuebao_id, hdkh.donvi_id, hdtb.loaitb_id, hdtb.dichvuvt_id,
            (case when hdkh.ctv_id > 0 then (select ma_nv  from admin.nhanvien@dataguard where nhanvien_id = hdkh.ctv_id and rownum=1) else null end) ma_tiepthi,
            (case when hdkh.ctv_id > 0 then (select ten_nv from admin.nhanvien@dataguard where nhanvien_id = hdkh.ctv_id and rownum=1) else null end) ten_tiepthi            
      from css.v_hd_khachhang@dataguard hdkh, css.v_hd_thuebao@dataguard hdtb
      where hdkh.hdkh_id=hdtb.hdkh_id 
      and trunc(hdkh.ngay_yc) between to_date('01/10/2024','dd/mm/yyyy') and to_date('31/10/2024','dd/mm/yyyy')
      and hdtb.dichvuvt_id <> 2 
;

select * from a_sbh_temp ;
--drop table SBH_202410_CT purge ;
CREATE TABLE SBH_202410_CT AS 
with v_nv as 
    (select ma_nv, ten_nv , ma_vtcv, ten_vtcv, ma_to, ten_to, ma_pb, ten_pb, nhanvien_id
        from ttkd_bsc.nhanvien nv where thang = 202410)

 select a.*, ma_nv manv_ra_pct, ten_nv tennv_ra_pct, ma_vtcv, ten_vtcv, ma_to mato_ra_pct, ten_to tento_ra_pct, ma_pb mapb_ra_pct, ten_pb tenpb_ra_pct,'SKM' loai,
        (case when ma_vtcv not in('VNP-HNHCM_BHKV_22','VNP-HNHCM_BHKV_28','VNP-HNHCM_BHKV_27') then 1
              when (( a.ma_tiepthi is null and nv.ma_nv is not null) or a.ma_tiepthi = nv.ma_nv) 
                    and (ma_vtcv in('VNP-HNHCM_BHKV_22','VNP-HNHCM_BHKV_28','VNP-HNHCM_BHKV_27')) then 1 else 0
         end ) dung_ma_tiepthi
 from a_sbh_temp a, v_nv nv
    where a.nhanvien_id = nv.nhanvien_id(+)
;
/* ----------- KHIEU NAI ------------- */
drop table a_sbh_temp purge ;
create table a_sbh_temp as
select a.*, db.khachhang_id
      , (select ma_kh from css.v_hd_khachhang@dataguard where khachhang_id=db.khachhang_id and rownum=1)ma_kh
      , (select ma_gd from css.v_hd_khachhang@dataguard where khachhang_id=db.khachhang_id and rownum=1)ma_gd
from 
(
    select to_char(trunc(a.ngay_tn),'yyyymm') thang, a.donvi_id, a.thuebao_id,            
              a.ma_tb,a.loaitb_id,a.dichvuvt_id, a.ngay_tn, a.nguoi_cn, a.nhanvien_id, a.nhanvien_gq_id, 
              'KHIEU NAI - TIEPNHAN'TEN_LOAIHD, MA_KN, ngay_GQ
      from qltn.v_khieunai@dataguard a where phanvung_id=28 and a.dichvuvt_id <> 2 
      and trunc(a.ngay_tn) between to_date('01/10/2024','dd/mm/yyyy') and to_date('31/10/2024','dd/mm/yyyy')
      union all
      select to_char(trunc(a.ngay_gq),'yyyymm') thang, a.donvi_id, a.thuebao_id,            
              a.ma_tb,a.loaitb_id,a.dichvuvt_id, a.ngay_tn, a.nguoi_cn, a.nhanvien_id, a.nhanvien_gq_id, 
              'KHIEU NAI - HOAN THANH' TEN_LOAIHD, MA_KN, NGAY_GQ
      from qltn.v_khieunai@dataguard a where phanvung_id=28 and a.dichvuvt_id <> 2 
      and trunc(a.ngay_gq) between to_date('01/10/2024','dd/mm/yyyy') and to_date('31/10/2024','dd/mm/yyyy')     
) a
left join (select db.khachhang_id, db.thuebao_id from css.v_db_thuebao@dataguard db) db on a.thuebao_id = db.thuebao_id
;

create table SBH_KHIEUNAI_202410_CT_TN AS
with v_nv as 
    (select ma_nv, ten_nv , ma_vtcv, ten_vtcv, ma_to, ten_to, ma_pb, ten_pb, nhanvien_id
        from ttkd_bsc.nhanvien nv where thang = 202410)
select a.*,
    nv.ma_nv manv_ra_pct, nv.ten_nv tennv_ra_pct, nv.ma_vtcv, nv.ten_vtcv ten_vtcv_ra_pct, nv.ma_to mato_ra_pct, nv.ten_to tento_ra_pct, nv.ma_pb mapb_ra_pct
  , nv.ten_pb tenpb_ra_pct, 'KHN' loai
from a_sbh_temp a, v_nv nv
where a.nhanvien_id = nv.nhanvien_id(+)
and ten_loaihd = 'KHIEU NAI - TIEPNHAN'
;

create table SBH_KHIEUNAI_202410_CT_GQ AS
with v_nv as 
    (select ma_nv, ten_nv , ma_vtcv, ten_vtcv, ma_to, ten_to, ma_pb, ten_pb, nhanvien_id
        from ttkd_bsc.nhanvien nv where thang = 202410)
select a.*,
    nv.ma_nv manv_gq, nv.ten_nv tennv_gq, nv.ma_vtcv ma_vtcv_gq, nv.ten_vtcv ten_vtcv_gq, nv.ma_to mato_gq, nv.ten_to tento_gq, nv.ma_pb mapb_gq, nv.ten_pb tenpb_gq,
    (Case when ( nv.ma_vtcv in('VNP-HNHCM_BHKV_22','VNP-HNHCM_BHKV_28','VNP-HNHCM_BHKV_27'))then 'X' else '' end)SBH_GQ, 'KHN' loai
from a_sbh_temp a, v_nv nv
where a.nhanvien_gq_id = nv.nhanvien_id(+)
and ten_loaihd = 'KHIEU NAI - HOAN THANH'

;
/* ------------ THU CUOC ------------- */
drop table a_sbh_temp purge ;
create table a_sbh_temp as 
with v_db as ( select tt.thanhtoan_id, tt.khachhang_id, kh.ma_kh
                from tinhcuoc.v_dbtt@dataguard tt, tinhcuoc.v_dbkh@dataguard kh
                    where tt.phanvung_id = 28 and tt.phanvung_id = 28 
                    and tt.ky_cuoc = '20241001' and kh.ky_cuoc = '20241001'
                    and tt.khachhang_id = kh.khachhang_id
             )

select distinct a.thang, a.phieu_id, a.thanhtoan_id, a.ngay_tt, a.ma_tb,a.ma_tt, a.dichvuvt_id, a.ma_tn, a.ngay_cn, a.nguoi_cn, a.httt_id,
                a.nhanvien_id, db.khachhang_id, db.ma_kh, a.loaihd_id, a.ten_loaihd,'PTH' loai
from 
     ( 
       Select distinct to_char(trunc(a.ngay_cn),'yyyymm') thang, a.phieu_id, a.thanhtoan_id, a.ngay_tt, a.ma_tt, a.ma_tn, b.nguoi_cn, a.ngay_cn
                    , a.nhanvien_id, a.httt_id, b.ma_tb, b.dichvuvt_id, 99 loaihd_id, 'THU CUOC' ten_loaihd
       From qltn.v_Bangphieutra@dataguard a, qltn.v_ct_tra@dataguard b
       Where a.phieu_id=b.phieu_id and b.dichvuvt_Id <> 2 and a.ky_cuoc='20240901' and b.ky_cuoc='20240901'
         and trunc(a.ngay_cn) between to_date('01/10/2024','dd/mm/yyyy') and to_date('31/10/2024','dd/mm/yyyy')
     ) a, v_db db
where  a.thanhtoan_id = db.thanhtoan_id(+)
--and a.dichvuvt_id = db.dichvuvt_id(+)
;

drop table SBH_CT_THU_202410_CT purge ;
create table SBH_CT_THU_202410_CT as 
with v_nv as 
    (select ma_nv, ten_nv , ma_vtcv, ten_vtcv, ma_to, ten_to, ma_pb, ten_pb, nhanvien_id
        from ttkd_bsc.nhanvien nv where thang = 202410)

select distinct a.*, ma_nv manv_ra_pct, ten_nv tennv_ra_pct, ma_vtcv, ten_vtcv, ma_to mato_ra_pct, ten_to tento_ra_pct, ma_pb mapb_ra_pct, ten_pb tenpb_ra_pct
from a_sbh_temp a, v_nv nv
    where a.MA_TN = NV.MA_NV(+)
;
create index SBH_CT_THU_202410_CT_matb on SBH_CT_THU_202410_CT(ma_tb) ;

/* ---------------------- VNP ----------------------- */
drop table SOLIEU_CCBS purge ;
create table SOLIEU_CCBS as 
select distinct a.* from ccs_hcm.SOLIEU_CCBS_202410@ttkddbbk2 a 
            where trunc(ngay_cn) between to_date('01/10/2024','dd/mm/yyyy') and to_date('31/10/2024','dd/mm/yyyy') ;
create index SOLIEU_CCBS_user_cn on SOLIEU_CCBS (user_cn) ;
create index SOLIEU_CCBS_matb on SOLIEU_CCBS (ma_tb) ;


select * from SBH_VNP_202410_CT ;
create table SBH_VNP_202410_CT as
--insert into SBH_VNP_202410_CT (ma_kh,ma_tb,loai_tb, manv_ra_pct, tennv_ra_pct,ma_vtcv, ten_vtcv, mato_ra_pct, tento_ra_pct, mapb_ra_pct, tenpb_ra_pct, user_cn, ngay_cn, ten_loaihd, ma_gd)
select ma_kh,ma_tb,loai_tb, manv_ra_pct, tennv_ra_pct,ma_vtcv, ten_vtcv, mato_ra_pct, tento_ra_pct, mapb_ra_pct, tenpb_ra_pct, user_cn, ngay_cn, ten_loaihd, ma_gd
from 
(
    select cast(a.ma_kh as varchar(20))ma_kh,cast(a.ma_tb as varchar(30))ma_tb,(case when a.loai_tb is null then 'CARD' else a.loai_tb end )loai_tb, 
              nv.manv_hrm manv_ra_pct,nv.ten_nv tennv_ra_pct,nv.ma_vtcv,nv.ten_vtcv,nv.ma_to mato_ra_pct,
              ( case when substr(a.user_cn,1,2) like 'dl%' then 'DAI LY' else nv.ten_to end ) tento_ra_pct, nv.ma_pb mapb_ra_pct,
              ( case when substr(a.user_cn,1,2) like 'dl%' then (select buucuc from nhuy.userld_202410_goc where user_ld=a.user_cn) 
                     else nv.ten_pb end ) tenpb_ra_pct,
              a.user_cn,a.ngay_cn,(case when a.loai_cn='THANH LY' then 'THANH LY/PTOC' else a.loai_cn end) ten_loaihd,
              (select ma_hd from danhba_dds_092024 where somay=a.ma_tb and ma_kh=a.ma_kh and rownum=1)ma_gd
    from 
         ( select distinct a.* from ccs_hcm.SOLIEU_CCBS_202410@ttkddbbk2 a 
            where trunc(ngay_cn) between to_date('01/10/2024','dd/mm/yyyy') and to_date('31/10/2024','dd/mm/yyyy')
         ) a left join ttkd_bsc.nhanvien nv on a.user_cn=nv.user_ccbs and nv.thang=202410
) 
;

commit ;
update SBH_VNP_202410_CT a set (ma_kh, ma_gd) = (select ma_kh, ma_hd from danhba_dds_092024 where somay=a.ma_tb)
-- select * from SBH_VNP_202410_CT a
where trim(a.loai_tb)  = 'POST'
;
commit ;

------END gom dữ liệu nguon----

-----BEGIN chọn các nghiệp vụ tính đơn giá-------
truncate table ttkd_bsc.ct_bsc_nghiepvu ;
create table ttkd_bsc.ct_bsc_nghiepvu as 
select * from ttkd_bsc.ct_bsc_nghiepvu ;

select *  delete from ttkd_bsc.ct_bsc_nghiepvu where thang = 202410;

/* --khong chọn-------- VI VNPT ------------ */
insert into ttkd_bsc.ct_bsc_nghiepvu (THANG, MA_TB, NGAY_DKY_VI, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB, LOAI, TEN_LOAIHD)
			select a.THANG, ma_tb, ngay_dky_vi, donvi, ma_nv, ten_nv, ten_to, ten_pb, ten_vtcv, ma_vtcv, ma_to, ma_pb, cast('VI_VNPTPAY' as varchar(20)) loai, 'CAI VI' TEN_LOAIHD
			from ttkdhcm_ktnv.hcm_vnptpay_ketqua a
						 join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and a.ma_hrm = nv.ma_nv and nv.thang = a.thang
			where ngay_dky_vi between to_date('01/10/2024 00:00:01','dd/mm/yyyy hh24:mi:ss') and to_date('31/10/2024 23:59:59','dd/mm/yyyy hh24:mi:ss') 
						and ma_hrm is not null
			;

/* ---khong chọn------- MOBILE MONEY ------------ */
insert into ttkd_bsc.ct_bsc_nghiepvu (THANG, MA_TB, NGAY_DKY_VI, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB, LOAI, TEN_LOAIHD)
		select a.THANG, ma_tb, ngay_dky_mm, donvi, ma_nv, ten_nv, ten_to, TEN_PB, TEN_VTCV, MA_VTCV, ma_to, ma_pb, 'VI_VNPTMM' loai, 'CAI VI' TEN_LOAIHD
		from ttkdhcm_ktnv.hcm_vmoney_ketqua a
					join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and a.ma_hrm = nv.ma_nv and nv.thang = a.thang
		where ngay_dky_mm between to_date('01/10/2024 00:00:01','dd/mm/yyyy hh24:mi:ss') and to_date('31/10/2024 23:59:59','dd/mm/yyyy hh24:mi:ss') 
					and not exists (select * from ttkd_bsc.ct_bsc_nghiepvu ex where loai = 'VI_VNPTPAY' and a.ma_tb = ex.ma_tb)
			;

/* ----khong chọn----- APP MYVNPT ------------ */
insert into ttkd_bsc.ct_bsc_nghiepvu (THANG, MA_TB, NGAY_DKY_VI, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB, LOAI, TEN_LOAIHD)
		select a.THANG, ma_tb, ngay_active, donvi, ma_nv, ten_nv, ten_to, TEN_PB, TEN_VTCV, MA_VTCV, ma_to, ma_pb, 'APP_MYVNPT' loai, 'CAI APP' TEN_LOAIHD
		from ttkdhcm_ktnv.HCM_VNPTAPP_ACTIVE a
					join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and a.ma_hrm = nv.ma_nv and nv.thang = a.thang
		where ngay_active between to_date('01/10/2024 00:00:01','dd/mm/yyyy hh24:mi:ss') and to_date('31/10/2024 23:59:59','dd/mm/yyyy hh24:mi:ss')
;
commit ;
/*----HauMai-Muc 4-----CCOS - KHIEU NAI - TIEPNHAN--------*/

	insert into ttkd_bsc.ct_bsc_nghiepvu (thang, MA_PA, MA_TB, NGHIEPVU, USER_CCOS, TEN_LOAIHD, LOAI, NGAY_DKY_VI, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
				select nv.thang, MA_PA, MA_TB, LOAI_KHIEUNAI || '; '|| LINHVUC_CHUNG || '; '|| LINHVUC_CON NGHIEPVU, a.USER_CCOS, 'KHIEU NAI - TIEP NHAN' TEN_LOAIHD, 'CCOS' loai
							, to_date(NGAY_TH, 'dd/mm/yyyy hh24:mi') NGAY_TH, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
				from tuyenngo.SBH_CCOS_202410_CT a
							join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and a.USER_CCOS = nv.user_ccos and nv.thang = 202410
				where a.USER_CCOS is not null and TEN_LOAIHD = 'TIEPNHAN'
;

/*----Nghievu Khoan-----CCOS - KHIEU NAI - DA XU LY--------*/

	insert into ttkd_bsc.ct_bsc_nghiepvu (thang, MA_PA, MA_TB, NGHIEPVU, USER_CCOS, TEN_LOAIHD, LOAI, NGAY_DKY_VI, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
				select nv.thang, MA_PA, MA_TB, LOAI_KHIEUNAI || '; '|| LINHVUC_CHUNG || '; '|| LINHVUC_CON NGHIEPVU, a.USER_CCOS, 'KHIEU NAI - DA XU LY' TEN_LOAIHD, 'CCOS' loai
							, to_date(NGAY_TH, 'dd/mm/yyyy hh24:mi') NGAY_TH, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
				from tuyenngo.SBH_CCOS_202410_CT a
							join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and a.USER_CCOS = nv.user_ccos and nv.thang = 202410
				where a.USER_CCOS is not null and TEN_LOAIHD = 'DA XU LY'
;
commit ;
/* ------khong ghi nhan------------ UPDATE USSD - DOISIM ------------------- 
-- thieu thông tin MA_KH, doi tuong KH ?? x? lý trên cùng 1 KH*/

/* SMRS vao mail tap doan, VAO  PHAN TICH -> NHOM BAO CAO DOI SIM 4G -> BC CHI TIET DOI SIM 4G - hh24:mi:ss */


insert into ttkd_bsc.ct_bsc_nghiepvu (MA_TB, NGHIEPVU, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB)
			select SO_THUE_BAO, 'Doi sim ' ||SO_SIM_CU || '_' || SO_SIM_MOI nghiepvu, to_date(THOI_GIAN_DOI,'dd/mm/yyyy hh24:mi:ss') THOI_GIAN_DOI, 'DOI SIM' TEN_LOAIHD, 'USSD' loai
						, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
			from tuyenngo.SBH_ussd_202410_CT a
						join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and  a.MANV_HRM = nv.ma_nv and nv.thang = 202410
			where a.MANV_HRM is not null 
;
commit ;
/* ------HauMai-Muc 29------------ UPDATE VINAGIFT ------------------- */
-- web http://10.70.115.121/ -> tang qua -> bao cao voucher

insert into ttkd_bsc.ct_bsc_nghiepvu (MA_TB, NGHIEPVU, NGAY_DKY_VI, TEN_LOAIHD, LOAI, USER_CCOS, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
		select SO_SERI, MUCDICH_SD, to_date(NGAY_SUDUNG,'dd/mm/yyyy') NGAY_SUDUNG, 'VINAGIFT' TEN_LOAIHD, 'VINAGIFT' loai, MANV_CN
						, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
		from tuyenngo.SBH_vinagift_202410_CT a
						join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and  a.MANV_HRM = nv.ma_nv and nv.thang = 202410
;
commit ;
/*----HauMai-Muc 3-----ONEBSS--- KHIEU NAI - TIEPNHAN -------------- 
--Chi xet khieu ai - TIEPNHAN
-- Theo MA_KN  */
--select * from NV_KHIEUNAI_202410_CT ;
-- drop table ttkd_bsc.x_temp_kn purge ;
	select * from ttkd_bsc.x_temp_kn;
	create table ttkd_bsc.x_temp_kn AS 
				select to_char(trunc(a.ngay_tn),'yyyymm') thang, a.donvi_id, a.thuebao_id, a.ma_tb,a.loaitb_id,a.dichvuvt_id,
                    a.ngay_tn, a.nguoi_cn, a.nhanvien_id, a.nhanvien_gq_id, MA_KN, ngay_GQ, TTKN_ID
      from qltn.v_khieunai@dataguard a
	 where a.ngay_tn between to_date('01/10/2024','dd/mm/yyyy') and to_date('31/10/2024','dd/mm/yyyy')
	 ;


	 insert into ttkd_bsc.ct_bsc_nghiepvu (THUEBAO_ID, KHACHHANG_ID, THANHTOAN_ID, MA_TB, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, ma_pa, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			select db.thuebao_id
						, db.khachhang_id, db.thanhtoan_id
					    , a.ma_tb, kh.ma_kh, a.ngay_tn
					    , 'KHIEU NAI - TIEPNHAN' TEN_LOAIHD, 'ONEBSS' loai, MA_KN
					    , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
				 from ttkd_bsc.x_temp_kn a
								join css_hcm.db_thuebao db on db.thuebao_id = a.thuebao_id
								join css_hcm.db_khachhang kh on db.KHACHHANG_ID = kh.KHACHHANG_ID
								join admin_hcm.nhanvien vi on a.nhanvien_id = vi.nhanvien_id
								join ttkd_bsc.nhanvien nv on nv.donvi = 'TTKD' and vi.ma_nv = nv.ma_nv and a.thang = nv.thang
				 where a.loaitb_id not in (20, 21)
	 ;
commit ;
/*----Nghiep vu Khoan-----ONEBSS--- KHIEU NAI- HOAN THANH -------------- 
--Chi xet khieu ai - HOAN THANH
-- Theo MA_KN  */
	 drop table ttkd_bsc.x_temp_gqkn purge;
	create table ttkd_bsc.x_temp_gqkn AS 
				select to_char(trunc(a.ngay_gq),'yyyymm') thang, a.donvi_id, a.thuebao_id, a.ma_tb,a.loaitb_id,a.dichvuvt_id, a.ngay_tn, a.nguoi_cn, a.nhanvien_id, a.nhanvien_gq_id, MA_KN, ngay_GQ, TTKN_ID
      from qltn.v_khieunai@dataguard a
	 where a.ngay_gq between to_date('01/10/2024','dd/mm/yyyy') and to_date('31/10/2024','dd/mm/yyyy')
	 ;
	 
	 insert into ttkd_bsc.ct_bsc_nghiepvu (THUEBAO_ID, KHACHHANG_ID, THANHTOAN_ID, MA_TB, NGAY_DKY_VI, TEN_LOAIHD, LOAI, ma_pa, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			select db.thuebao_id
						, db.khachhang_id, db.thanhtoan_id
					    , a.ma_tb, a.ngay_gq
					    , 'KHIEU NAI- HOAN THANH' TEN_LOAIHD, 'ONEBSS' loai, MA_KN
					    , nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
				 from ttkd_bsc.x_temp_gqkn a
								join css_hcm.db_thuebao db on db.thuebao_id = a.thuebao_id
								join admin_hcm.nhanvien vi on a.nhanvien_id = vi.nhanvien_id
								join ttkd_bsc.nhanvien nv on vi.ma_nv = nv.ma_nv and a.thang = nv.thang
				 where a.loaitb_id not in (20, 21)
	 ;
     commit ;
	 /* ---khong ghi nhận------------ ONEBSS - DAT COC MOI ------------ 
	-- theo MA_KH
	-- lo?i tr? trùng ONEBSS - DAT COC MOI voi ONEBSS - LAPDATMOI, GHTT
	*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tbl as( select THANG, MA_KH, TEN_LOAIHD, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
									, row_number() over(partition by MA_KH, nhanvien_id order by rowid) rnk
							from tuyenngo.sbh_202410_CT
							where loaihd_id = 31 and tthd_id = 6 and MANV_RA_PCT is not null
						)
			select MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID
						, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
			from tbl a
						join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
			where rnk = 1
		;
	/* ----Nghiep vu Khoan----------- ONEBSS - TIEP NHAN KHAO SAT DAT MOI ------------ 
	-- theo MA_KH
	-- lo?i tr? trùng ONEBSS - TIEP NHAN KHAO SAT DAT MOI voi ONEBSS - LAPDATMOI
	-- update thêm  c?t MA_KH*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with bdk as(select THANG, MA_KH, TEN_LOAIHD, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
									, row_number() over(partition by MA_KH, nhanvien_id order by rowid) rnk
							from tuyenngo.sbh_202410_CT
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
	-- Update thêm c?t MA_KH*/
		insert into ttkd_bsc.ct_bsc_nghiepvu (ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
				with bdk as(select THANG, MA_KH, TEN_LOAIHD, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
										, row_number() over(partition by MA_KH, nhanvien_id order by rowid) rnk
								from tuyenngo.sbh_202410_CT
								where loaihd_id = 26 and tthd_id = 6 and MANV_RA_PCT is not null
							)
				select MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID
							, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
				from bdk a
							join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
				where rnk = 1
		;
		/* -----Nghiep vu Khoan---------- ONEBSS - BIENDONGKHAC ------------ 
	-- theo MA_KH*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with bdk as(select THANG, MA_KH, TEN_LOAIHD, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
									, row_number() over(partition by MA_KH, nhanvien_id order by rowid) rnk
							from tuyenngo.sbh_202410_CT
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
		-- loai tru trong Nghiep vu LAPMOI*/
		insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, hdkh_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, hdkh_id, MANV_RA_PCT, NGAY_YC
										, row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
								from tuyenngo.sbh_202410_CT a
												join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202410
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
		- - theo thue bao*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tly as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
									, row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
							from tuyenngo.sbh_202410_CT a
											join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202410
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
		- - theo thue bao*/
	insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
									, row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
							from tuyenngo.sbh_202410_CT a
											join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202410
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
							from tuyenngo.sbh_202410_CT a
											join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202410
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
							from tuyenngo.sbh_202410_CT a
											join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202410
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
							from tuyenngo.sbh_202410_CT
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
							from tuyenngo.sbh_202410_CT
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
									from tuyenngo.sbh_202410_CT
									where loaihd_id = 27 and tthd_id = 6  and dichvuvt_id != 2 and MANV_RA_PCT is not null
								)
					select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id, hdkh_id
								, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
					from tbl a
								join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
					where rnk = 1
			;
			/* -----Không ghi nhận---------- ONEBSS - THAY DOI DAT COC ------------ 
		-- Nghiem thu
		-- theo thue bao
		-- lo?i tr? trùng trong các nghi?p khác*/
			insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
									, row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
							from tuyenngo.sbh_202410_CT a
											join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202410
							where loaihd_id = 32 and tthd_id = 6 and MANV_RA_PCT is not null
						)
			select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id
						, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
			from tbl a
						join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
			where rnk = 1
			;
			/* -----HauMai-Muc 16---------- ONEBSS - THAY DOI DICH VU ------------ 
			-- Nghiem thu
			-- theo thue bao
			-- thay doi sau cung trong thang*/
			insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
											, row_number() over(partition by thuebao_id, a.nhanvien_id order by a.ngay_yc desc) rnk
								from tuyenngo.sbh_202410_CT a
												join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202410
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
								from tuyenngo.sbh_202410_CT a
												join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202410
								where loaihd_id = 28 and tthd_id = 6 and MANV_RA_PCT is not null
						)
			select MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID
						, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
			from tbl a
						join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
			where rnk = 1;
			
			/* --------HauMai-Muc 17,18------- ONEBSS - THAYDOI IMS MEGAWAN ------------ 
			-- Nghiem thu
			-- theo thue bao
		*/
			insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
											, row_number() over(partition by MA_TB, a.nhanvien_id order by a.ngay_yc DESC) rnk
								from tuyenngo.sbh_202410_CT a
												join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202410
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
		--Lo?i tr? trùng thue bao LAPMOI
		*/
		insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
											, row_number() over(partition by thuebao_id, a.nhanvien_id order by a.ngay_yc) rnk
								from tuyenngo.sbh_202410_CT a
												join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202410
								where loaihd_id = 41 and tthd_id = 6 and MANV_RA_PCT is not null
						)
			select ma_tb, MA_KH, ngay_yc, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'ONEBSS' loai , KHACHHANG_ID, thuebao_id
						, nv.thang, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
			from tbl a
						join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and a.thang = nv.thang and nv.donvi = 'TTKD'
			where rnk = 1;
			/* ------HauMai-Muc 20,21--------- ONEBSS - THAYDOI TOCDO ADSL, TSL ------------ 
			-- Nghiem thu
			-- theo thue bao
			-- Lo?i tr? trùng thue bao LAPMOI
		*/
			insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, thuebao_id, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
											, row_number() over(partition by thuebao_id, a.nhanvien_id order by a.ngay_yc DESC) rnk
								from tuyenngo.sbh_202410_CT a
												join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202410
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
								from tuyenngo.sbh_202410_CT a
												join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202410
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
		--lo?i tr? trùng ONEBSS - THU CUOC so v?i ONEBSS - Nghiep v? khac
		*/
		insert into ttkd_bsc.ct_bsc_nghiepvu (ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, KHACHHANG_ID, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tbl as(select a.THANG, MA_KH, TEN_LOAIHD, KHACHHANG_ID, ngay_tt
--											, MANV_RA_PCT, TENNV_RA_PCT, MA_VTCV, TEN_VTCV, MATO_RA_PCT, TENTO_RA_PCT, MAPB_RA_PCT, TENPB_RA_PCT
											, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
											, row_number() over(partition by ma_kh, a.nhanvien_id order by a.ngay_tt) rnk
								from tuyenngo.sbh_ct_thu_202410_ct a
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
			with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
									, row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
							from tuyenngo.sbh_202410_CT a
											join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202410
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
			with tbl as(select a.THANG, ma_tb, MA_KH, TEN_LOAIHD, thuebao_id, KHACHHANG_ID, MANV_RA_PCT, NGAY_YC
									, row_number() over(partition by ma_tb, a.nhanvien_id order by NGAY_YC) rnk
							from tuyenngo.sbh_202410_CT a
											join ttkd_bsc.nhanvien nv on a.nhanvien_id = nv.nhanvien_id and nv.thang = 202410
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
			with tbl as(select nv.thang, ma_tb, MA_KH, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
											, row_number() over(partition by ma_tb, a.MANV_RA_PCT order by a.ngay_cn DESC) rnk
											, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
								from tuyenngo.sbh_vnp_202410_ct a
												join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410 
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
			with tbl as(select nv.thang, ma_tb, MA_KH, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
											, row_number() over(partition by ma_tb, a.MANV_RA_PCT order by a.ngay_cn DESC) rnk
											, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
								from tuyenngo.sbh_vnp_202410_ct a
												join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410 
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
			with tbl as(select nv.thang, ma_tb, MA_KH, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
											, row_number() over(partition by ma_tb, a.MANV_RA_PCT order by a.ngay_cn DESC) rnk
											, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
								from tuyenngo.sbh_vnp_202410_ct a
												join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410 
								where TEN_LOAIHD = 'CNTTTB' and MANV_RA_PCT is not null
						)
			select ma_tb, MA_KH, ngay_cn, upper(bo_dau(TEN_LOAIHD)) TEN_LOAIHD, 'CCBS' loai 
						, thang, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
			from tbl
			where rnk = 1
			;
			/* -----HauMai-Muc 7---------- CCBS- DANG KY HUY CHUYEN DOI GOI CUOC ------------ 
				-- Nghiem thu
				-- theo KH, c?p nh?t ??u tiên
				-- ghi 1 lan/ngay
				-- thieu thong tin MA_KH, doi tuong KH de xu ly tren cung 1 KH de loc 100 nghiep vu
				delete from ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd = 'DANG KY HUY CHUYEN DOI GOI CUOC' and thang = 202410;
				*/
			insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, doituong_id, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
					with tbl as(select nv.thang, ma_tb, MA_KH, doituong_id, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
													, row_number() over(partition by MA_KH, a.MANV_RA_PCT, trunc(a.ngay_cn) order by a.ngay_cn) rnk
													, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
										from tuyenngo.sbh_vnp_202410_ct a
														join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
										where TEN_LOAIHD = 'DANG KY HUY CHUYEN DOI GOI CUOC' and MANV_RA_PCT is not null and nvl(doituong_id, 1) in (1, 25)
										)
					select ma_tb, MA_KH, doituong_id, trunc(ngay_cn) ngay_cn, TEN_LOAIHD, 'CCBS' loai 
								, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
					from tbl
					where rnk = 1
			;
			insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, doituong_id, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
					with tbl as(select nv.thang, ma_tb, MA_KH, doituong_id, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
													, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
													, row_number() over(partition by MA_KH, ma_tb, a.MANV_RA_PCT order by a.ngay_cn) rnk
										from tuyenngo.sbh_vnp_202410_ct a
														join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
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
			with tbl as(select nv.thang, ma_tb, MA_KH, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
											, row_number() over(partition by ma_tb, a.MANV_RA_PCT order by a.ngay_cn) rnk
											, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
								from tuyenngo.sbh_vnp_202410_ct a
												join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
								where TEN_LOAIHD = 'DK NHOM DAI DIEN HUONG CUOC' and MANV_RA_PCT is not null --and ma_kh = '010030778'
								)
			select ma_tb, MA_KH, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
						, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
			from tbl
			where rnk = 1
			;
			
			/* ---------HauMai-Muc 9------ CCBS - DK/DC/HUY NGUONG CN ------------ 
				-- Nghiem thu
				-- theo thue bao
				-- ?K l?n cu?i cùng trong 1 tháng
				-- Lo?i tr? HMM VNP CHUA vì không có trong danh m?c Nghi?p v?
				*/
		insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tbl as(select nv.thang, ma_tb, MA_KH, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
											, row_number() over(partition by ma_tb, a.MANV_RA_PCT order by a.ngay_cn desc) rnk
											, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
								from tuyenngo.sbh_vnp_202410_ct a
												join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
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
				delete from ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd = 'DOI SIM' and thang = 202410;
				*/
			insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, DOITUONG_ID, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
						with tbl as(select nv.thang, ma_tb, MA_KH, DOITUONG_ID, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
														, row_number() over(partition by ma_tb, a.MANV_RA_PCT order by a.ngay_cn) rnk
														, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
											from tuyenngo.sbh_vnp_202410_ct a
															join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
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
											from tuyenngo.sbh_vnp_202410_ct a
															join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
											where TEN_LOAIHD = 'DOI SIM' and MANV_RA_PCT is not null and nvl(doituong_id, 1) not in (1, 25)
											)
						select ma_tb, MA_KH, DOITUONG_ID, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
									, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
						from tbl
						where rnk = 1
			;
			
			/* -----HauMai-Muc 11---------- CCBS - DONG MO DV|0 ------------ 
				-- Nghiem thu
				-- theo MAKH, c?p nh?t ??u tiên
				-- 100 nghiep vu trong ngay/KH
				-- thieu thong tin MA_KH, doi tuong KH de xu ly tren cung 1 KH de loc 100 nghiep vu
				delete from ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd = 'DONG MO DV|0' and thang = 202410;
				*/
			insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, doituong_id, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB)
				with tbl as(select nv.thang, ma_tb, MA_KH, doituong_id, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
												, row_number() over(partition by MA_KH, a.MANV_RA_PCT order by a.ngay_cn) rnk
												, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
									from tuyenngo.sbh_vnp_202410_ct a
													join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
									where TEN_LOAIHD = 'DONG MO DV|0' and MANV_RA_PCT is not null and nvl(doituong_id, 1) in (1, 25)
									)
				select MA_TB, MA_KH, doituong_id, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
							, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
				from tbl
				where rnk = 1
			;
			insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, doituong_id, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
					with tbl as(select nv.thang, ma_tb, MA_KH, doituong_id, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
--													, row_number() over(partition by MA_KH, ma_tb, a.MANV_RA_PCT order by a.ngay_cn) rnk
													, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
										from tuyenngo.sbh_vnp_202410_ct a
														join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
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
				delete from ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd = 'DONG MO DV|1' and thang = 202410;
				*/
		insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, doituong_id, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB)
				with tbl as(select nv.thang, ma_tb, MA_KH, doituong_id, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
												, row_number() over(partition by MA_KH, a.MANV_RA_PCT order by a.ngay_cn) rnk
												, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
									from tuyenngo.sbh_vnp_202410_ct a
													join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
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
									from tuyenngo.sbh_vnp_202410_ct a
													join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
									where TEN_LOAIHD = 'DONG MO DV|1' and MANV_RA_PCT is not null and nvl(doituong_id, 1) not in (1, 25)
									)
				select MA_TB, MA_KH, doituong_id, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
							, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
				from tbl
				where rnk = 1
			;
	commit ;		
			/* -----HauMai-Muc 13---------- CCBS - DONG TRUOC GOI CUOC ------------ 
				-- Nghiem thu
				-- theo MAKH, c?p nh?t ?âu tiên
				-- 100 nghiep vu trong ngay/KH
				-- thieu thông tin MA_KH, doi tuong KH ?? x? lý trên cùng 1 KH de l?c 100 nghi?p v?
				delete from ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd = 'DONG TRUOC GOI CUOC' and thang = 202410;
				*/
			insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, doituong_id, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB)
						with tbl as(select nv.thang, ma_tb, MA_KH, doituong_id, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
														, row_number() over(partition by MA_KH, a.MANV_RA_PCT order by a.ngay_cn) rnk
														, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
											from tuyenngo.sbh_vnp_202410_ct a
															join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
											where TEN_LOAIHD = 'DONG TRUOC GOI CUOC' and MANV_RA_PCT is not null and nvl(doituong_id, 1) in (1, 25)
											)
						select ma_tb, MA_KH, doituong_id, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
									, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB
						from tbl
						where rnk = 1
			;
			insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, doituong_id, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB)
						with tbl as(select nv.thang, ma_tb, MA_KH, doituong_id, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
														, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
														, row_number() over(partition by MA_KH, ma_tb, a.MANV_RA_PCT order by a.ngay_cn) rnk
											from tuyenngo.sbh_vnp_202410_ct a
															join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
											where TEN_LOAIHD = 'DONG TRUOC GOI CUOC' and MANV_RA_PCT is not null and nvl(doituong_id, 1) not in (1, 25)
											)
						select ma_tb, MA_KH, doituong_id, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
									, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, ten_vtcv, MA_VTCV, MA_TO, MA_PB
						from tbl
						where rnk = 1
			;
			
			/* -----HauMai-Muc 14---------- CCBS - THANH LY/PTOC ------------ 
				-- Nghiem thu
				-- theo thue bao
				*/
			insert into ttkd_bsc.ct_bsc_nghiepvu (ma_tb, ma_kh, NGAY_DKY_VI, TEN_LOAIHD, LOAI, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB)
			with tbl as(select nv.thang, ma_tb, MA_KH, TEN_LOAIHD, MANV_RA_PCT, NGAY_CN, USER_CN
											, row_number() over(partition by ma_tb, a.MANV_RA_PCT order by a.ngay_cn) rnk
											, nv.donvi, nv.ma_nv, nv.ten_nv, nv.ten_to, nv.ten_pb, nv.ten_vtcv, nv.ma_vtcv, nv.ma_to, nv.ma_pb
								from tuyenngo.sbh_vnp_202410_ct a
												join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
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
								from tuyenngo.sbh_vnp_202410_ct a
												join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
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
										from tuyenngo.sbh_vnp_202410_ct a
														join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
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
								from tuyenngo.sbh_vnp_202410_ct a
												join ttkd_bsc.nhanvien nv on a.MANV_RA_PCT = nv.ma_nv and nv.donvi = 'TTKD' and nv.thang = 202410
								where TEN_LOAIHD = 'CHUYEN QUYEN' and MANV_RA_PCT is not null --and ma_kh = '010030778'
								)
			select ma_tb, MA_KH, ngay_cn, TEN_LOAIHD, 'CCBS' loai 
						, THANG, DONVI, MA_NV, TEN_NV, TEN_TO, TEN_PB, TEN_VTCV, MA_VTCV, MA_TO, MA_PB
			from tbl
			where rnk = 1
			;
commit ;
			--loai tr? các ??n v? khác
			delete from ttkd_bsc.ct_bsc_nghiepvu where donvi = 'VTTP';
			--lo?i tr? trùng BAN THIET BI vs Nghiep v? LAPDATMOI
			delete from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'BAN THIET BI' and 'ONEBSS' = loai and a.thang = 202410
						and exists (select 1 from ttkd_bsc.ct_bsc_nghiepvu where TEN_LOAIHD = 'LAP DAT MOI' and 'ONEBSS' = loai and thuebao_id = a.thuebao_id and thang = a.thang)
						;
			--lo?i tr? trùng TAO MOI GOI DA DICH VU vs Nghiep v? LAPDATMOI
			delete from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'TAO MOI GOI DA DICH VU' and 'ONEBSS' = loai and a.thang = 202410
						and exists (select 1 from ttkd_bsc.ct_bsc_nghiepvu where TEN_LOAIHD = 'LAP DAT MOI' and 'ONEBSS' = loai and thuebao_id = a.thuebao_id and thang = a.thang)
						;
			--lo?i tr? trùng ONEBSS - THUKHAC so v?i ONEBSS - Nghiep v? khac
			delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'THU KHAC' and 'ONEBSS' = loai and a.thang = 202410
						and exists (select 1 from ttkd_bsc.ct_bsc_nghiepvu where TEN_LOAIHD != 'THU KHAC' and 'ONEBSS' = loai and ma_kh = a.ma_kh and thang = a.thang)
			;
			--lo?i tr? trùng ONEBSS - THU CUOC so v?i ONEBSS - Nghiep v? khac
			delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'THU CUOC' and 'ONEBSS' = loai and a.thang = 202410
						and exists (select 1 from ttkd_bsc.ct_bsc_nghiepvu where TEN_LOAIHD != 'THU CUOC' and 'ONEBSS' = loai and ma_kh = a.ma_kh and thang = a.thang)
			;
			--lo?i tr? trùng USSD - DOSIM trong CCBS - DOISIM
			delete from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'DOI SIM' and 'USSD' = loai and a.thang = 202410
						and exists (select 1 from ttkd_bsc.ct_bsc_nghiepvu where TEN_LOAIHD = 'DOI SIM' and 'CCBS' = loai and ma_tb = a.ma_tb and thang = a.thang)
			;
			--lo?i tr? trùng CCBS - CNTTTB voi CCBS - CAP NHAT DB
			delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'CNTTTB' and 'CCBS' = loai and a.thang = 202410
						and exists (select * from  tuyenngo.sbh_vnp_202410_ct where ten_loaihd = 'CAP NHAT DB' and a.thang = thang and ma_tb = a.ma_tb)
			;
			--lo?i tr? trùng ONEBSS - THAYDOIDATCOC voi ONEBSS - NGHIEPVUKHAC
			delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'THAY DOI DAT COC' and 'ONEBSS' = loai and a.thang = 202410
						and exists (select distinct TEN_LOAIHD, loai from  ttkd_bsc.ct_bsc_nghiepvu
											where ten_loaihd != 'THAY DOI DAT COC' and 'ONEBSS' = loai and ma_tb = a.ma_tb and thang = a.thang)
			;
			--lo?i tr? trùng ONEBSS - THAYDOITHONGTIN-GIAHANDICHVUCNTT voi ONEBSS - LAPDATMOI
			delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'THAY DOI THONG TIN - GIA HAN DICH VU CNTT' and 'ONEBSS' = loai and a.thang = 202410
						and exists (select * from  ttkd_bsc.ct_bsc_nghiepvu
											where ten_loaihd = 'LAP DAT MOI' and 'ONEBSS' = loai and ma_tb = a.ma_tb and thang = a.thang)
			;
			--lo?i tr? trùng ONEBSS - THAYDOITOCDO ADSL, TSL voi ONEBSS - LAPDATMOI
			delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'THAY DOI TOC DO INTERNET' and 'ONEBSS' = loai and a.thang = 202410
						and exists (select * from  ttkd_bsc.ct_bsc_nghiepvu
											where ten_loaihd = 'LAP DAT MOI' and 'ONEBSS' = loai and ma_tb = a.ma_tb and thang = a.thang)
			;
			--lo?i tr? trùng ONEBSS - TIEP NHAN KHAO SAT DAT MOI voi ONEBSS - LAPDATMOI
			delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'TIEP NHAN KHAO SAT DAT MOI' and 'ONEBSS' = loai and a.thang = 202410
						and exists (select * from  ttkd_bsc.ct_bsc_nghiepvu
											where ten_loaihd = 'LAP DAT MOI' and 'ONEBSS' = loai and ma_kh = a.ma_kh and thang = a.thang)
			;
			
			--lo?i tr? trùng ONEBSS - TIEP NHAN LAP DAT MOI voi ONEBSS - LAPDATMOI
			delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'TIEP NHAN LAP DAT MOI' and 'ONEBSS' = loai and a.thang = 202410
						and exists (select * from  ttkd_bsc.ct_bsc_nghiepvu
											where ten_loaihd = 'LAP DAT MOI' and 'ONEBSS' = loai and ma_kh = a.ma_kh and thang = a.thang)
			;
			
			--lo?i tr? trùng ONEBSS - DAT COC MOI voi ONEBSS - LAPDATMOI
			delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'DAT COC MOI' and 'ONEBSS' = loai and a.thang = 202410
						and exists (select * from  ttkd_bsc.ct_bsc_nghiepvu
											where ten_loaihd = 'LAP DAT MOI' and 'ONEBSS' = loai and ma_kh = a.ma_kh and thang = a.thang)
			;
			--lo?i tr? trùng CCBS - THUCUOC voi CCBS - NGHIEP VU KHAC
			delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'THU CUOC' and loai = 'CCBS' and a.thang = 202410
						and exists (select * from  ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd != 'THU CUOC' and loai = 'CCBS' and a.thang = thang and ma_tb = a.ma_tb)
			;
			
			--lo?i tr? trùng CCBS - THU VUOTNGUONG/TAMTHU CN/THUHO voi CCBS - NGHIEP VU KHAC
			delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'THU VUOTNGUONG/TAMTHU CN/THUHO' and 'CCBS' = loai and a.thang = 202410
						and exists (select 1 from  ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd != 'THU VUOTNGUONG/TAMTHU CN/THUHO' and 'CCBS' = loai and a.thang = thang and ma_tb = a.ma_tb)
			;
			
			--loại trừ trùng CCBS - DONG MO DV|0 voi CCBS - NGHIEP VU KHAC
			delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'DONG MO DV|0' and 'CCBS' = loai and a.thang = 202410
						and exists (select 1 from  ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd != 'DONG MO DV|0' and 'CCBS' = loai and a.thang = thang and ma_tb = a.ma_tb)
			;
			--loại trừ trùng CCBS - DONG MO DV|0 voi CCBS - NGHIEP VU KHAC
			delete from ttkd_bsc.ct_bsc_nghiepvu a
--			select * from ttkd_bsc.ct_bsc_nghiepvu a
					where TEN_LOAIHD = 'DONG MO DV|1' and 'CCBS' = loai and a.thang = 202410
						and exists (select 1 from  ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd != 'DONG MO DV|1' and 'CCBS' = loai and a.thang = thang and ma_tb = a.ma_tb)
			;
commit;
select a.*
from ttkd_bsc.ct_bsc_nghiepvu a
where a.thang = 202410 and a.donvi = 'TTKD'
;
commit;
---xuat du lieu test TONG QUAN---
with nv100 as (select ma_nv, LOAI, TEN_LOAIHD, TEN_PB, TEN_TO, ten_nv, ma_kh, NGAY_DKY_VI, count(*) sl_nv
										, case when count(*) < 26 then 0.7
													when count(*) >= 26 then 3.5 *  trunc(count(*)/101 + 1)
											else -1
											end sl
										--, row_number() over(partition by MA_KH, a.MANV_RA_PCT, trunc(a.ngay_cn) order by a.ngay_cn) rnk
--										SELECT* 
							from ttkd_bsc.ct_bsc_nghiepvu a
							where TEN_LOAIHD in ('DANG KY HUY CHUYEN DOI GOI CUOC', 'DOI SIM', 'DONG MO DV|0', 'DONG MO DV|1', 'DONG TRUOC GOI CUOC')
--											and nvl(doituong_id, 1) not in (1, 25) 
											and a.thang = 202410 and a.donvi = 'TTKD'
							group by ma_nv, LOAI, TEN_LOAIHD, TEN_PB, TEN_TO, ten_nv, ma_kh, NGAY_DKY_VI
				)
, tbl1 as (				
					select LOAI, TEN_LOAIHD, a.TEN_PB, a.TEN_TO, a.ma_nv, a.ten_nv, nv.ten_vtcv, sum(sl) sanluong
									, case when TEN_LOAIHD in ('CHUYEN DOI LOAI HINH THUE BAO'
															, 'KHIEU NAI - HOAN THANH', 'BIEN DONG KHAC', 'TIEP NHAN KHAO SAT DAT MOI'
															, 'TIEP NHAN LAP DAT MOI', 'TAO MOI GOI DA DICH VU', 'THAY DOI GOI DA DICH VU') and loai = 'ONEBSS' then 'DM_KHOAN'
												when TEN_LOAIHD in ('CAP NHAT DB') and loai = 'CCBS' then 'DM_KHOAN'
												when TEN_LOAIHD in ('KHIEU NAI - DA XU LY') and loai = 'CCOS' then 'DM_KHOAN'
												when TEN_LOAIHD in ('LAP DAT MOI - CNTT', 'LAP DAT MOI - CNTTQLDA', 'LAP DAT MOI - BRCD', 'BAN THIET BI') and loai = 'ONEBSS' then 'DM_PTM'
												when TEN_LOAIHD in ('HMM TRA SAU') and loai = 'CCBS' then 'DM_PTM'
														else 'DM_HAUMAI' end DANHMUC
					from nv100 a
								join ttkd_bsc.nhanvien nv on a.ma_nv = nv.ma_nv and nv.thang = 202410
					group by LOAI, TEN_LOAIHD, a.TEN_PB, a.TEN_TO, a.ma_nv, a.ten_nv, nv.ten_vtcv
					union all
							select LOAI, TEN_LOAIHD, a.TEN_PB, a.TEN_TO, a.ma_nv, a.ten_nv, nv.ten_vtcv, count(*) sanluong
										, case when TEN_LOAIHD in ('CHUYEN DOI LOAI HINH THUE BAO'
															, 'KHIEU NAI - HOAN THANH', 'BIEN DONG KHAC', 'TIEP NHAN KHAO SAT DAT MOI'
															, 'TIEP NHAN LAP DAT MOI', 'TAO MOI GOI DA DICH VU', 'THAY DOI GOI DA DICH VU') and loai = 'ONEBSS' then 'DM_KHOAN'
												when TEN_LOAIHD in ('CAP NHAT DB') and loai = 'CCBS' then 'DM_KHOAN'
												when TEN_LOAIHD in ('KHIEU NAI - DA XU LY') and loai = 'CCOS' then 'DM_KHOAN'
												when TEN_LOAIHD in ('LAP DAT MOI - CNTT', 'LAP DAT MOI - CNTTQLDA', 'LAP DAT MOI - BRCD', 'BAN THIET BI') and loai = 'ONEBSS' then 'DM_PTM'
												when TEN_LOAIHD in ('HMM TRA SAU') and loai = 'CCBS' then 'DM_PTM'
														else 'DM_HAUMAI' end DANHMUC
							  from ttkd_bsc.ct_bsc_nghiepvu a
										join ttkd_bsc.nhanvien nv on a.ma_nv = nv.ma_nv and nv.thang = 202410
							  where a.thang = 202410 and a.donvi = 'TTKD'
												and TEN_LOAIHD not in ('DANG KY HUY CHUYEN DOI GOI CUOC', 'DOI SIM', 'DONG MO DV|0', 'DONG MO DV|1', 'DONG TRUOC GOI CUOC')
							  group by LOAI, TEN_LOAIHD, a.TEN_PB, a.TEN_TO, a.ma_nv, a.ten_nv, nv.ten_vtcv
							  order by LOAI, TEN_LOAIHD
		  )
select a.*, b.heso, a.SANLUONG * b.HESO sanluong_heso
from tbl1 a
		left join hocnq_ttkd.nghiepvu_heso b on a.loai = b.loai and a.ten_loaihd = b.ten_loaihd
		  ;
		  select * from hocnq_ttkd.nghiepvu_heso;
		  /*
		  select * from hocnq_ttkd.nghiepvu_heso;
		  create table hocnq_ttkd.nghiepvu_heso as
			select distinct LOAI, TEN_LOAIHD, cast(null as number) heso from ttkd_bsc.ct_bsc_nghiepvu where thang = 202410;
		  		select * from ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd = 'DONG MO DV|0' and thang = 202410;
			select * from tuyenngo.sbh_vnp_202410_ct a;
			select distinct LOAI_CN from tuyenngo.solieu_ccbs a;
			select distinct ten_loaihd from tuyenngo.sbh_202410_CT a;
			select * from tuyenngo.sbh_ct_thu_202410_ct a where manv_ra_pct is not null;
		  */