--=== QUY ĐỔI NGHIỆP VỤ - anh Nguyên hướng dẫn
select loai,ten_loaihd,ma_nv,1 quydoi
  from ct_nghiepvu_sbh 
 where thang=202501 and khong_tinh is null 
   and ten_loaihd not in ('DONG MO DV|0','DONG MO DV|1','BIEN DONG KHAC','THU KHAC')
 
  union all
--=== gom quy doi 100
select loai, ten_loaihd, ma_nv,floor(count()/100)+case when mod(count(),100)>0 then 1 else 0 end quydoi 
from (
		select distinct loai, 'DONG MO DV|0|1'ten_loaihd, ma_nv, ma_kh, ma_tb, to_char(ngay_cn,'dd/mm/yyyy')ngay_cn
        from ct_nghiepvu_sbh 
        where thang=202501 and khong_tinh is null and ten_loaihd in ('DONG MO DV|0','DONG MO DV|1')
	 )
group by loai,ten_loaihd, ma_nv, ma_kh, ngay_cn
 
  union all
--=== bien dong khac theo ma_tb
select loai,ten_loaihd,ma_nv,count(distinct ma_tb)quydoi
  from ct_nghiepvu_sbh 
 where thang=202501 and khong_tinh is null and ten_loaihd='BIEN DONG KHAC'
 group by loai,ten_loaihd,ma_nv

 union all
 --=== bien dong khac theo 0.25*ma_kh
select 'THU CUOC' loai,'THU CUOC' ten_loaihd,ma_nv,count(distinct ma_kh)*0.25
  from ct_nghiepvu_sbh a
 where thang=202501 and khong_tinh is null and ten_loaihd='THU KHAC'
 group by ma_to,ma_nv