create or replace procedure ico_mea_stg.spr_warehouse_updater(
    pio_err in out nocopy varchar2 )
is
begin
  update ico_mea_stg.whsoprshploc
  set cmpcod                                                                              = 'me1'
  where ( cmpcod, mstdocnum, docowridr, dupnum, seqnum, arpcod, whscod, loccod, stucod ) in
    (select x.cmpcod,
      x.mstdocnum mstdocnum,
      x.docowridr docowridr,
      x.dupnum dupnum,
      x.seqnum seqnum,
      x.arpcod,
      loc.whscod,
      loc.loccod,
      loc.stucod
    from ico_mea_stg.whsoprshploc loc
    inner join
      (select mst.cmpcod,
        mst.mstdocnum,
        mst.dupnum,
        mst.seqnum,
        mst.docowridr,
        expflt.arpcod,
        expflt.fltoprsta,
        sum(seg.mftpcs)segpcs,
        (select sum(shploc.locpcs)
        from ico_mea_stg.whsoprshploc shploc
        where shploc.mstdocnum = mst.mstdocnum
        and shploc.docowridr   = mst.docowridr
        and shploc.dupnum      = mst.dupnum
        and shploc.seqnum      = mst.seqnum
        and shploc.arpcod      = expflt.arpcod
        ) locpcs
      from ico_mea_stg.oprshpmst mst,
        ico_mea_stg.oprsegshp seg,
        ico_mea_stg.oprarpexpflt expflt,
        ico_mea_stg.oprfltseg fltseg
      where mst.mstdocnum  = seg.mstdocnum
      and mst.docowridr    = seg.docowridr
      and mst.dupnum       = seg.dupnum
      and mst.seqnum       = seg.seqnum
      and mst.cmpcod       = seg.cmpcod
      and seg.fltnum       = fltseg.fltnum
      and seg.fltseqnum    = fltseg.fltseqnum
      and seg.fltcaridr    = fltseg.fltcaridr
      and seg.segsernum    = fltseg.segsernum
      and expflt.cmpcod    = fltseg.cmpcod
      and expflt.fltnum    = fltseg.fltnum
      and expflt.fltseqnum = fltseg.fltseqnum
      and expflt.fltcaridr = fltseg.fltcaridr
      and expflt.arpcod    = fltseg.pol
      and expflt.fltoprsta = 'f'
      group by mst.cmpcod,
        mst.mstdocnum,
        mst.dupnum,
        mst.seqnum,
        mst.docowridr,
        expflt.arpcod,
        expflt.fltoprsta
      ) x
    on loc.mstdocnum  = x.mstdocnum
    and loc.docowridr = x.docowridr
    and loc.dupnum    = x.dupnum
    and loc.seqnum    = x.seqnum
    and loc.arpcod    = x.arpcod
    inner join ico_mea_stg.oprarpshp arp
    on arp.mstdocnum  = x.mstdocnum
    and arp.docowridr = x.docowridr
    and arp.dupnum    = x.dupnum
    and arp.seqnum    = x.seqnum
    and arp.cmpcod    = x.cmpcod
    and arp.arpcod    = x.arpcod
    where x.locpcs    > 0
    and segpcs        = arp.mftpcs
    and ( arp.bdppcs  = arp.mftpcs
    and arp.avlpcs    = 0 )
    and loc.cmpcod    = 'me'
    );
--end;
commit;
exception
when others then
pio_err := 'failed'||sqlerrm;
dbms_output.put_line ('in update query' );
end spr_warehouse_updater;
/