
CREATE procedure [dbo].[sp_CalculateNationalSalesAndRiskPerformance]
@businessdate datetime

as

declare @date  varchar(8), @bulanx int, @agingdate date
declare @datestart varchar(8),@datestart1 varchar(8)

set @date = convert(varchar(8),@businessdate,112)
set @datestart = left(@date,6)+'01'
set @bulanx = month(@date)
set @datestart1 = left(@date,4)+'0101'
set @agingdate = dateadd(dd,-1,@businessdate)
print @agingdate
--set @akhirbulanlalu = convert(varchar(8),dateadd(d,-1,left(convert(varchar(8),@date,112),6)+'01'),112)

delete from Fact_NationalPerformanceSummary where bulan = @bulanx

INSERT INTO Fact_NationalPerformanceSummary
(tahun,bulan,SalesRegRetail,SalesRegMultiguna,SalesCaptive,SalesCompany,EPD,Kol2NJF,Kol2JF,Kol3UpNJF,Kol3UpJF,RECOVERY,
TOTALPRPAVG,PBT,TotalOSPrincipal,TotalAccount,SalesAccountRegular,SalesAccountCaptive,SalesAccountMultiguna)	
select 2026,@bulanx,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

update Fact_NationalPerformanceSummary  set SalesRegRetail=isnull(xxx,0),SalesAccountRegular=isnull(yyy,0)
from (select sum(s.ntf)xxx,COUNT(*) yyy
from DataWarehouse.dbo.sales s with (nolock)
inner join DataWarehouse.dbo.agreement a with (nolock) on s.branchid = a.branchid and s.applicationid = a.applicationid
inner join DataWarehouse.dbo.AgreementAsset aa with (nolock) on aa.branchid = s.branchid and aa.applicationid = s.applicationid
inner join DataWarehouse.dbo.AssetMaster am on am.AssetCode = aa.AssetCode
inner join DataWarehouse.dbo.Branch b with (nolock) on b.branchid = s.branchid
where salesdate between @datestart1 and @date and isnull(s.iscaptive,0) = 0 and aa.usednew = 'N' and
eksagreement is NULL --and b.areaid <> 215
)x where bulan = @bulanx


----sales reg multiguna
update Fact_NationalPerformanceSummary set SalesRegMultiguna= isnull(xxx,0),SalesAccountMultiguna=isnull(yyy,0)
from (select sum(s.ntf)xxx,COUNT(*) yyy
from DataWarehouse.dbo.sales s with (nolock)
inner join DataWarehouse.dbo.agreement a with (nolock) on s.branchid = a.branchid and s.applicationid = a.applicationid
inner join DataWarehouse.dbo.Branch b with (nolock) on b.branchid = s.branchid
inner join DataWarehouse.dbo.AgreementAsset aa with (nolock) on aa.branchid = s.branchid and aa.applicationid = s.applicationid
where salesdate between @datestart1 and @date and
a.eksagreement is NULL and isnull(s.iscaptive,0) = 0 and aa.usednew = 'U' --and b.areaid <> 215
)x where bulan = @bulanx

update Fact_NationalPerformanceSummary  set SalesCaptive= isnull(xxx,0),SalesAccountCaptive=isnull(yyy,0)
from (select sum(s.ntf)xxx,COUNT(*) yyy
from DataWarehouse.dbo.sales s with (nolock)
inner join DataWarehouse.dbo.agreement a with (nolock) on s.branchid = a.branchid and s.applicationid = a.applicationid
inner join DataWarehouse.dbo.Branch b with (nolock) on b.branchid = s.branchid
inner join DataWarehouse.dbo.AgreementAsset aa with (nolock) on aa.branchid = s.branchid and aa.applicationid = s.applicationid
where salesdate between @datestart1 and @date and
a.eksagreement is NULL and isnull(s.iscaptive,0) = 1
)x where bulan = @bulanx


select @datestart1, @date

update Fact_NationalPerformanceSummary set SalesCompany=isnull(yyy,0)
from (select sum(s.ntf) yyy
from DataWarehouse.dbo.sales s with (nolock)
inner join DataWarehouse.dbo.agreement a with (nolock) on s.branchid = a.branchid and s.applicationid = a.applicationid
inner join DataWarehouse.dbo.AgreementAsset aa with (nolock) on aa.branchid = s.branchid and aa.applicationid = s.applicationid
inner join DataWarehouse.dbo.AssetMaster am on am.AssetCode = aa.AssetCode
inner join DataWarehouse.dbo.Branch b with (nolock) on b.branchid = s.branchid
inner join DataWarehouse.dbo.Customer c with (nolock) on c.customerid = a.customerid
where salesdate between @datestart1 and @date and eksagreement is NULL and c.CustomerType= 'C' and b.areaid <> 215
)x where bulan = @bulanx

update Fact_NationalPerformanceSummary set SalesCompany=(SalesCompany/isnull(yyy,0))*100.00
from (select sum(s.ntf) yyy
from DataWarehouse.dbo.sales s with (nolock)
inner join DataWarehouse.dbo.agreement a with (nolock) on s.branchid = a.branchid and s.applicationid = a.applicationid
inner join DataWarehouse.dbo.AgreementAsset aa with (nolock) on aa.branchid = s.branchid and aa.applicationid = s.applicationid
inner join DataWarehouse.dbo.AssetMaster am on am.AssetCode = aa.AssetCode
inner join DataWarehouse.dbo.Branch b with (nolock) on b.branchid = s.branchid
inner join DataWarehouse.dbo.Customer c with (nolock) on c.customerid = a.customerid
where salesdate between @datestart1 and @date and eksagreement is NULL and b.areaid <> 215
)x where bulan = @bulanx

--update current collection
select month(@date) bulan1,
dag.applicationid, 
are.areaid,
ltrim(rtrim(are.areafullname)) areafullname,
brc.branchfullname,
brc.branchid,
daysoverdue,
dag.kolslik,
dag.totalosprincipal as totalosprincipal,
case when (dagm.applicationid is not null) then isnull(dagm.totalosprincipal,0) else 0 end as ospjf,
case when (dagm.applicationid is not null) then dag.totalosprincipal-isnull(dagm.totalosprincipal,0) else dag.totalosprincipal end as ospnjf
into #tmpaging
from Staging.dbo.dailyaging dag
left join DataWarehouse.dbo.dailyagingmirror as dagm on dagm.applicationid=dag.applicationid and dagm.agingdate=dag.agingdate and dagm.dailymonthly='M'
LEFT JOIN DataWarehouse.dbo.branch brc ON dag.branchid = brc.branchid
LEFT JOIN DataWarehouse.dbo.area are ON are.areaid = brc.areaid
where dag.agingdate = @businessdate and 
dag.defaultstatusda<>'WO' and dag.dailymonthly='M' 
and dag.totalosprincipal>0


--select @agingdate,* from #tmpaging

--select 'kol2jf',@agingdate,* from #tmpaging x where daysoverdue between 1 and 90

declare @wherecond varchar(8000)

select month(@date) bulan1,
datediff(day,isnull(NextInstallmentDate,MaturityDate),@date)+1  od,
isnull(kolslik,1)kolslik,
da.totalosprincipal totalosprincipal, a.NTF, golivedate, eksagreement, a.branchid, a.applicationid
,case when (dagm.applicationid is not null) then isnull(dagm.totalosprincipal,0) else 0 end as ospjf,
case when (dagm.applicationid is not null) then da.totalosprincipal-isnull(dagm.totalosprincipal,0) else da.totalosprincipal end as ospnjf
into #tmpaging90 
from DataWarehouse.dbo.agreement a  with (nolock) 
left join DataWarehouse.dbo.agreementasset aa  with (nolock) on a.branchid = aa.branchid and a.applicationid = aa.applicationid
--left join CWOApplication cwo on cwo.branchid = a.branchid and cwo.applicationid = a.ApplicationID
left join Staging.dbo.dailyaging da on da.branchid = a.branchid and da.applicationid = a.ApplicationID
left join DataWarehouse.dbo.dailyagingmirror as dagm on dagm.applicationid=da.applicationid and dagm.agingdate=da.agingdate and dagm.dailymonthly='M'
where  da.totalosprincipal > 0 and da.DefaultStatusDA <> 'WO' and da.dailymonthly = 'M' and da.agingdate = @businessdate

--and cwo.applicationid is null

--actual aging

update  Fact_NationalPerformanceSummary set kol2NJF = (x/(select sum(totalosprincipal) from #tmpaging))*100.00 from  ---kol2 ALL Manage
(select sum(ospnjf) x from #tmpaging x where daysoverdue between 1 and 90)x 
where bulan = @bulanx

update  Fact_NationalPerformanceSummary set Kol2JF = (x/(select sum(ospnjf) from #tmpaging))*100.00 from ---Kol2 NJF
(select sum(ospjf) x  from #tmpaging x where daysoverdue between 1 and 90)x 
where bulan = @bulanx

update  Fact_NationalPerformanceSummary set Kol3UpNJF = (x/(select sum(totalosprincipal) from #tmpaging))*100.00 from ---kol>=3 All Manage
(select sum(ospnjf) x  from #tmpaging x where daysoverdue > 90)x 
where bulan = @bulanx

update  Fact_NationalPerformanceSummary set Kol3UpJF = (isnull(x,0)/(select sum(ospnjf) from #tmpaging))*100.00 from --kol>=3 NJF
(select sum(ospjf) x  from #tmpaging x where daysoverdue > 90)x
where bulan = @bulanx

--EPD
declare @tglsales2 datetime, @tglsales1 datetime

set @agingdate = dateadd(d,-1,dateadd(m,1,convert(datetime,right(str(year(@date)),4)+right('0'+ltrim(str(@bulanx)),2)+'01',112)))
set @tglsales2=dateadd(d,-1,left(convert(varchar(8),@agingdate,112),6)+'01')
set @tglsales1=dateadd(m,-10,left(convert(varchar(8),@agingdate,112),6)+'01')

update Fact_NationalPerformanceSummary set EPD = x*1.00
from (
select sum(a.OutstandingPrincipal)x
from DataWarehouse.dbo.agreement a with (nolock) 
left join DataWarehouse.dbo.AssetRepossessionOrder aro with (nolock) on a.branchid = aro.branchid and a.applicationid = aro.applicationid and
	InventoryDate <= @date
left join (select a.branchid,a.applicationid,MAX(a.insclaimseqno)insclaimseqno from DataWarehouse.dbo.InsuranceClaim a
	inner join (select branchid,applicationid,max(insclaimseqno)insclaimseqno,max(sequencenumber)sequencenumber from DataWarehouse.dbo.InsuranceClaimActivityCheck
	group by branchid,applicationid)b on b.BranchID = a.BranchID and b.ApplicationID = a.ApplicationID and a.insclaimseqno = b.insclaimseqno
--	where ClaimType = 'TLO'
	group by a.branchid,a.applicationid)ic on ic.BranchID = a.BranchID and ic.ApplicationID = a.ApplicationID
left join DataWarehouse.dbo.InsuranceCLPClaimRequest clpc on clpc.BranchID = a.BranchID AND clpc.ApplicationID = a.ApplicationID  and clpc.ClaimStatus <> 'J'
where a.golivedate between @tglsales1 and @tglsales2 and a.eksagreement is null
and datediff(day,a.NextInstallmentDate,@date)+1 > 7
and aro.branchid is null 
and ic.BranchID is null and clpc.BranchId is null
and a.ContractStatus not in('RRD','EXP') )
x where bulan = @bulanx

update Fact_NationalPerformanceSummary set EPD =(EPD+isnull(LORx,0))
from (
select sum(outstandingprincipalonreposses*0.33)LORx
from DataWarehouse.dbo.assetrepossessionorder aro
inner join DataWarehouse.dbo.Agreement a on a.branchid = aro.branchid and a.applicationid = aro.applicationid
left join DataWarehouse.dbo.writeoff wo on wo.branchid = aro.branchid and wo.applicationid = ARO.applicationid and  wo.approvalstatus = 'A'
where a.golivedate between @tglsales1 and @tglsales2 and a.eksagreement is null and 
sellingdate is null and (releasepostingdate is null or releasepostingdate > @date) and wo.branchid is null
)x where bulan = @bulanx

update Fact_NationalPerformanceSummary set EPD =(EPD+isnull(LORx,0))
from (
select isnull(sum(outstandingprincipalonreposses-sellingamount),0)LORx
from DataWarehouse.dbo.assetrepossessionorder aro
inner join DataWarehouse.dbo.Agreement a on a.branchid = aro.branchid and a.applicationid = aro.applicationid
left join DataWarehouse.dbo.writeoff wo on wo.branchid = aro.branchid and wo.applicationid = ARO.applicationid and  wo.approvalstatus = 'A'
where a.golivedate between @tglsales1 and @tglsales2 and a.eksagreement is null and sellingdate is not null and wo.branchid is null
)x where bulan = @bulanx

update Fact_NationalPerformanceSummary set EPD =(EPD/x*1.00) * 100.00
from (
select sum(isnull(da.TotalOSPrincipal,a.outstandingprincipal))x
from DataWarehouse.dbo.agreement a with (nolock) 
left join Staging.dbo.DailyAging da on da.BranchID = a.BranchID and da.ApplicationID = a.ApplicationID and da.agingdate = @tglsales2
where a.golivedate between @tglsales1 and @tglsales2 and a.eksagreement is null
)x 
where bulan = @bulanx


--REC
update Fact_NationalPerformanceSummary set RECOVERY = RECx from  (
select isnull(sum(recoveryamount),0) Recx 
from DataWarehouse.dbo.vwrecovery a with (nolock) 
where postingdate between @datestart1 and @date)x
where bulan = @bulanx

select year(agingdate) tahunx , month(agingdate) bulanx,
totalosprincipal xx, a.eksagreement, x.branchid, x.applicationid, daysoverdue od
into #tmpFR
from Staging.dbo.dailyaging  x
inner join branch b on b.branchid = x.branchid
left join agreement a on a.branchid = x.branchid and a.applicationid = x.applicationid
where agingdate = @date --and x.totalosprincipal > 0 --and IsRepo2 = 0

create table #tmpdata3(
	totalosprincipal numeric(17,2),
	account int
)

insert into #tmpdata3
select a.OutstandingPrincipal totalosprincipal,
1 account
from DataWarehouse.dbo.agreement a 
left join CoreDB.dbo.CWOApplication cwo on cwo.branchid = a.branchid and cwo.applicationid = a.ApplicationID
where contractstatus in ('LIV','ICL','ICP') and a.OutstandingPrincipal > 0 and a.defaultstatus <> 'WO'
and cwo.applicationid is null

update Fact_NationalPerformanceSummary set TOTALPRPAVG = x, TotalOSPrincipal = x, TotalAccount = y from  (
select sum(totalosprincipal)x, SUM(account)y
from #tmpdata3
) x where bulan = @bulanx 

update Fact_NationalPerformanceSummary set PBT = isnull(PATActual,0) from
(
select sum(TargetAmount)/1000000.00 PATActual
from mpitarget where branchid = '001' and targetdesc = 'PAA' and year(date) = year(@date) and month(date) = @bulanx
) x where bulan = @bulanx


drop table #tmpaging90
