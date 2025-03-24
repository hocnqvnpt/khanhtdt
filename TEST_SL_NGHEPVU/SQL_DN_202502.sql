
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- DOANH NGHIEP
--- xuat du lieu test TONG QUAN --- TẤT CẢ --- KHÔNG VCC --- 3 P.DN tính block 100
with tmp_nv as (
    select a.*
    from ttkd_bsc.ct_bsc_nghiepvu a
    where a.thang = 202502
          and a.donvi = 'TTKD'
          and a.loai in ('ONEBSS','CCBS','CCOS')
          and a.ten_loaihd in
            (   'Lắp đặt mới','BAN THIET BI','THAY DOI THONG TIN - GIA HAN DICH VU CNTT'
                ,'HMM TRA SAU','DANG KY HUY CHUYEN DOI GOI CUOC','DK NHOM DAI DIEN HUONG CUOC','DK/DC/HUY NGUONG CN','DONG TRUOC GOI CUOC','THANH LY/PTOC'
                ,'KHIEU NAI - TIEP NHAN'
            )
)
, nv100 as (	
				select ma_nv, LOAI, TEN_LOAIHD, MA_PB, TEN_PB, MA_TO, TEN_TO, ten_nv, ma_kh, NGAY_DKY_VI
                        , count(*) sl_nv
						-- 3 P.DN thì tính gom block 100
						, ( Case when MA_PB in ('VNP0702300', 'VNP0702400', 'VNP0702500')
								    then ( case when count(*) >= 1 then ceil( count(*) / 100 ) else -1 end )
								 when MA_PB not in ('VNP0702300', 'VNP0702400', 'VNP0702500')
									then count(*)
						    End ) sl
--                      , row_number() over(partition by MA_KH, a.MANV_RA_PCT, trunc(a.ngay_cn) order by a.ngay_cn) rnk
				--from ttkd_bsc.ct_bsc_nghiepvu a
                from ttkd_bsc.tmp_nv a
				where a.thang = 202502 and a.donvi = 'TTKD'
                      and TEN_LOAIHD in ('HMM TRA SAU', 'DOI SIM', 'DANG KY HUY CHUYEN DOI GOI CUOC', 'DONG MO DV|0', 'DONG MO DV|1', 'DONG TRUOC GOI CUOC')   --ĐK 2024-11
					  and not exists (  Select 1 From ttkd_bct.cuoc_thuebao_ttkd where loaitb_id = 149 and ma_tb = a.ma_tb )        --ĐK 2024-11 tách VCC
--					  and nvl(doituong_id, 1) not in (1, 25) 
				group by ma_nv, LOAI, TEN_LOAIHD, MA_PB, TEN_PB, MA_TO, TEN_TO, ten_nv, ma_kh, NGAY_DKY_VI
             )
, tbl1 as (				
				select LOAI, TEN_LOAIHD, a.MA_PB, a.TEN_PB, a.MA_TO, a.TEN_TO, a.ma_nv, a.ten_nv, nv.ten_vtcv, sum(sl) sanluong
								, case when TEN_LOAIHD in ('CHUYEN DOI LOAI HINH THUE BAO'
														, 'KHIEU NAI - HOAN THANH', 'BIEN DONG KHAC', 'TIEP NHAN KHAO SAT DAT MOI'
														, 'TIEP NHAN LAP DAT MOI', 'TAO MOI GOI DA DICH VU', 'THAY DOI GOI DA DICH VU') and loai = 'ONEBSS' then 'DM_KHOAN'
											when TEN_LOAIHD in ('CAP NHAT DB') and loai = 'CCBS' then 'DM_KHOAN'
											when TEN_LOAIHD in ('KHIEU NAI - DA XU LY') and loai = 'CCOS' then 'DM_KHOAN'
											when TEN_LOAIHD in ('LAP DAT MOI - CNTT', 'LAP DAT MOI - CNTTQLDA', 'LAP DAT MOI - BRCD', 'BAN THIET BI') and loai = 'ONEBSS' then 'DM_PTM'
											when TEN_LOAIHD in ('HMM TRA SAU') and loai = 'CCBS' then 'DM_PTM'
													else 'DM_HAUMAI' end DANHMUC
				from nv100 a
					join ttkd_bsc.nhanvien nv on a.ma_nv = nv.ma_nv and nv.thang = 202502
				group by LOAI, TEN_LOAIHD, a.MA_PB, a.TEN_PB, a.MA_TO, a.TEN_TO, a.ma_nv, a.ten_nv, nv.ten_vtcv
			union all
				select LOAI, TEN_LOAIHD, a.MA_PB, a.TEN_PB, a.MA_TO, a.TEN_TO, a.ma_nv, a.ten_nv, nv.ten_vtcv, count(*) sanluong
							, case when TEN_LOAIHD in ('CHUYEN DOI LOAI HINH THUE BAO'
												, 'KHIEU NAI - HOAN THANH', 'BIEN DONG KHAC', 'TIEP NHAN KHAO SAT DAT MOI'
												, 'TIEP NHAN LAP DAT MOI', 'TAO MOI GOI DA DICH VU', 'THAY DOI GOI DA DICH VU') and loai = 'ONEBSS' then 'DM_KHOAN'
									when TEN_LOAIHD in ('CAP NHAT DB') and loai = 'CCBS' then 'DM_KHOAN'
									when TEN_LOAIHD in ('KHIEU NAI - DA XU LY') and loai = 'CCOS' then 'DM_KHOAN'
									when TEN_LOAIHD in ('LAP DAT MOI - CNTT', 'LAP DAT MOI - CNTTQLDA', 'LAP DAT MOI - BRCD', 'BAN THIET BI') and loai = 'ONEBSS' then 'DM_PTM'
									when TEN_LOAIHD in ('HMM TRA SAU') and loai = 'CCBS' then 'DM_PTM'
											else 'DM_HAUMAI' end DANHMUC
				  --from ttkd_bsc.ct_bsc_nghiepvu a
                  from ttkd_bsc.tmp_nv a
							join ttkd_bsc.nhanvien nv on a.ma_nv = nv.ma_nv and nv.thang = 202502
				  where a.thang = 202502 and a.donvi = 'TTKD'
						and TEN_LOAIHD not in ('HMM TRA SAU', 'DOI SIM', 'DANG KY HUY CHUYEN DOI GOI CUOC', 'DONG MO DV|0', 'DONG MO DV|1', 'DONG TRUOC GOI CUOC')   --ĐK 2024-11
						and not exists ( Select 1 From ttkd_bct.cuoc_thuebao_ttkd where loaitb_id = 149 and ma_tb = a.ma_tb )        --DK theo file excel 2024-11 tách VCC
				  group by LOAI, TEN_LOAIHD, a.MA_PB, a.TEN_PB, a.MA_TO, a.TEN_TO, a.ma_nv, a.ten_nv, nv.ten_vtcv
				  order by LOAI, TEN_LOAIHD
		  )
select *
from tbl1
Where MA_PB in ('VNP0702300','VNP0702400','VNP0702500')
Order by MA_PB;
--select a.*, b.heso, a.SANLUONG * b.HESO sanluong_heso from tbl1 a
--left join hocnq_ttkd.nghiepvu_heso b on a.loai = b.loai and a.ten_loaihd = b.ten_loaihd;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- xuat du lieu test TONG QUAN --- Thuê bao VCC --- 3 P.DN tính block 100
with tmp_nv as (
    select a.*
    from ttkd_bsc.ct_bsc_nghiepvu a
    where a.thang = 202502
          and a.donvi = 'TTKD'
          and a.loai in ('ONEBSS','CCBS','CCOS')
          and a.ten_loaihd in
            (   'Lắp đặt mới','BAN THIET BI','THAY DOI THONG TIN - GIA HAN DICH VU CNTT'
                ,'HMM TRA SAU','DANG KY HUY CHUYEN DOI GOI CUOC','DK NHOM DAI DIEN HUONG CUOC','DK/DC/HUY NGUONG CN','DONG TRUOC GOI CUOC','THANH LY/PTOC'
                ,'KHIEU NAI - TIEP NHAN'
            )
)
, nv100 as (	
				select ma_nv, LOAI, TEN_LOAIHD, MA_PB, TEN_PB, MA_TO, TEN_TO, ten_nv, ma_kh, NGAY_DKY_VI
						, count(*) sl_nv
						-- 3 P.DN thì tính gom block 100
						, ( Case when MA_PB in ('VNP0702300', 'VNP0702400', 'VNP0702500')
								    then (case when count(*) >= 1 then ceil( count(*) / 100 ) else -1 end)
								 when MA_PB not in ('VNP0702300', 'VNP0702400', 'VNP0702500')
									then count(*)
						    End ) sl
--                      , row_number() over(partition by MA_KH, a.MANV_RA_PCT, trunc(a.ngay_cn) order by a.ngay_cn) rnk
--				SELECT * 
				--from ttkd_bsc.ct_bsc_nghiepvu a
                from tmp_nv a
--				where TEN_LOAIHD in ('DANG KY HUY CHUYEN DOI GOI CUOC', 'DOI SIM', 'DONG MO DV|0', 'DONG MO DV|1', 'DONG TRUOC GOI CUOC')
				where a.thang = 202502 and a.donvi = 'TTKD'
                      and TEN_LOAIHD in ('HMM TRA SAU', 'DOI SIM', 'DANG KY HUY CHUYEN DOI GOI CUOC', 'DONG MO DV|0', 'DONG MO DV|1', 'DONG TRUOC GOI CUOC')   --ĐK 2024-11
					  and exists (  Select 1 From ttkd_bct.cuoc_thuebao_ttkd where loaitb_id = 149 and ma_tb = a.ma_tb )	--ĐK 2024-11 tách VCC
--					  and nvl(doituong_id, 1) not in (1, 25) 
				group by ma_nv, LOAI, TEN_LOAIHD, MA_PB, TEN_PB, MA_TO, TEN_TO, ten_nv, ma_kh, NGAY_DKY_VI
             )
, tbl1 as (				
                select LOAI, TEN_LOAIHD, a.MA_PB, a.TEN_PB, a.MA_TO, a.TEN_TO, a.ma_nv, a.ten_nv, nv.ten_vtcv, sum(sl) sanluong
						, case when TEN_LOAIHD in ('CHUYEN DOI LOAI HINH THUE BAO'
												, 'KHIEU NAI - HOAN THANH', 'BIEN DONG KHAC', 'TIEP NHAN KHAO SAT DAT MOI'
												, 'TIEP NHAN LAP DAT MOI', 'TAO MOI GOI DA DICH VU', 'THAY DOI GOI DA DICH VU') and loai = 'ONEBSS' then 'DM_KHOAN'
									when TEN_LOAIHD in ('CAP NHAT DB') and loai = 'CCBS' then 'DM_KHOAN'
									when TEN_LOAIHD in ('KHIEU NAI - DA XU LY') and loai = 'CCOS' then 'DM_KHOAN'
									when TEN_LOAIHD in ('LAP DAT MOI - CNTT', 'LAP DAT MOI - CNTTQLDA', 'LAP DAT MOI - BRCD', 'BAN THIET BI') and loai = 'ONEBSS' then 'DM_PTM'
									when TEN_LOAIHD in ('HMM TRA SAU') and loai = 'CCBS' then 'DM_PTM'
											else 'DM_HAUMAI' end DANHMUC
                from nv100 a
                    join ttkd_bsc.nhanvien nv on a.ma_nv = nv.ma_nv and nv.thang = 202502
                group by LOAI, TEN_LOAIHD, a.MA_PB, a.TEN_PB, a.MA_TO, a.TEN_TO, a.ma_nv, a.ten_nv, nv.ten_vtcv
                union all
                select LOAI, TEN_LOAIHD, a.MA_PB, a.TEN_PB, a.MA_TO, a.TEN_TO, a.ma_nv, a.ten_nv, nv.ten_vtcv, count(*) sanluong
						, case when TEN_LOAIHD in ('CHUYEN DOI LOAI HINH THUE BAO'
											, 'KHIEU NAI - HOAN THANH', 'BIEN DONG KHAC', 'TIEP NHAN KHAO SAT DAT MOI'
											, 'TIEP NHAN LAP DAT MOI', 'TAO MOI GOI DA DICH VU', 'THAY DOI GOI DA DICH VU') and loai = 'ONEBSS' then 'DM_KHOAN'
								when TEN_LOAIHD in ('CAP NHAT DB') and loai = 'CCBS' then 'DM_KHOAN'
								when TEN_LOAIHD in ('KHIEU NAI - DA XU LY') and loai = 'CCOS' then 'DM_KHOAN'
								when TEN_LOAIHD in ('LAP DAT MOI - CNTT', 'LAP DAT MOI - CNTTQLDA', 'LAP DAT MOI - BRCD', 'BAN THIET BI') and loai = 'ONEBSS' then 'DM_PTM'
								when TEN_LOAIHD in ('HMM TRA SAU') and loai = 'CCBS' then 'DM_PTM'
										else 'DM_HAUMAI' end DANHMUC
                --from ttkd_bsc.ct_bsc_nghiepvu a
                from tmp_nv a
                    join ttkd_bsc.nhanvien nv on a.ma_nv = nv.ma_nv and nv.thang = 202502
                where a.thang = 202502 and a.donvi = 'TTKD' and LOAI = 'CCBS'
                      and TEN_LOAIHD not in ('HMM TRA SAU', 'DOI SIM', 'DANG KY HUY CHUYEN DOI GOI CUOC', 'DONG MO DV|0', 'DONG MO DV|1', 'DONG TRUOC GOI CUOC')	--ĐK 2024-11
					  and exists (  Select 1 From ttkd_bct.cuoc_thuebao_ttkd where loaitb_id = 149 and ma_tb = a.ma_tb )	--ĐK 2024-11 tách VCC
                group by LOAI, TEN_LOAIHD, a.MA_PB, a.TEN_PB, a.MA_TO, a.TEN_TO, a.ma_nv, a.ten_nv, nv.ten_vtcv
                order by LOAI, TEN_LOAIHD
		  )
select *
from tbl1
Where MA_PB in ('VNP0702300','VNP0702400','VNP0702500','VNP0703000')
--Where TEN_TO like 'Cửa%'
Order by MA_PB;
--select a.*, b.heso, a.SANLUONG * b.HESO sanluong_heso from tbl1 a
--left join hocnq_ttkd.nghiepvu_heso b on a.loai = b.loai and a.ten_loaihd = b.ten_loaihd;

select * from hocnq_ttkd.nghiepvu_heso;
/*
select * from hocnq_ttkd.nghiepvu_heso;
create table hocnq_ttkd.nghiepvu_heso as
select distinct LOAI, TEN_LOAIHD, cast(null as number) heso from ttkd_bsc.ct_bsc_nghiepvu where thang = 202502;
	select * from ttkd_bsc.ct_bsc_nghiepvu where ten_loaihd = 'DONG MO DV|0' and thang = 202502;
select * from tuyenngo.sbh_vnp_202502_ct a;
select distinct LOAI_CN from tuyenngo.solieu_ccbs a;
select distinct ten_loaihd from tuyenngo.sbh_202502_CT a;
select * from tuyenngo.sbh_ct_thu_202502_ct a where manv_ra_pct is not null;
*/