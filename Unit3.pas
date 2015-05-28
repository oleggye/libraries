unit Unit3;

interface
  uses Math;
  type
    Newrecord = record // new record type for returning a result;
    latitude: real;
    longitude: real;
    end;

  function utmToLatLng(zone: byte; easting: real; northing: real; northernHemisphere: Boolean): Newrecord;
implementation
  function utmToLatLng(zone: byte; easting: real; northing: real; northernHemisphere: Boolean): Newrecord;
   var
    rec: NewRecord;
    a: longint;
    e: real;
    e1sq: real;
    k0,arc,mu,ei,ca,cb,cc,phi1,cd,n0,fact1,r0,_a1,_a2,_a3,dd0,fact2,t0,q0,fact3,fact4
    ,lof1,lof2,lof3: real;

     begin
       if not northernHemisphere then
        northing := 10000000 - northing;

    a := 6378137 ;
    e := 0.081819191 ;
    e1sq := 0.006739497 ;
    k0 := 0.9996     ;

    arc := northing / k0;
    mu := arc / (a * (1 - power(e, 2) / 4.0 - 3 * power(e, 4) / 64.0 - 5 * power(e, 6) / 256.0));

    ei := (1 - power((1 - e * e), (1 / 2.0))) / (1 + power((1 - e * e), (1 / 2.0)))  ;

    ca := 3 * ei / 2 - 27 * power(ei, 3) / 32.0 ;

    cb := 21 * power(ei, 2) / 16 - 55 * power(ei, 4) / 32 ;
    cc := 151 * power(ei, 3) / 96       ;
    cd := 1097 * power(ei, 4) / 512     ;
    phi1 := mu + ca * Sin(2 * mu) + cb * Sin(4 * mu) + cc * Sin(6 * mu) + cd * Sin(8 * mu) ;

    n0 := a / power((1 - power((e * Sin(phi1)), 2)), (1 / 2.0)) ;

    r0 := a * (1 - e * e) / power((1 - power((e * Sin(phi1)), 2)), (3 / 2.0)) ;
    fact1 := n0 * math.tan(phi1) / r0                                ;

    _a1 := 500000 - easting;
    dd0 := _a1 / (n0 * k0) ;
    fact2 := dd0 * dd0 / 2  ;

    t0 := power(math.tan(phi1), 2)       ;
    Q0 := e1sq * power(Cos(phi1), 2)  ;
    fact3 := (5 + 3 * t0 + 10 * Q0 - 4 * Q0 * Q0 - 9 * e1sq) * power(dd0, 4) / 24 ;

    fact4 := (61 + 90 * t0 + 298 * Q0 + 45 * t0 * t0 - 252 * e1sq - 3 * Q0 * Q0) * power(dd0, 6) / 720  ;

    lof1 := _a1 / (n0 * k0)   ;
    lof2 := (1 + 2 * t0 + Q0) * power(dd0, 3) / 6.0 ;
    lof3 := (5 - 2 * Q0 + 28 * t0 - 3 * power(Q0, 2) + 8 * e1sq + 24 * power(t0, 2)) * power(dd0, 5) / 120;
    _a2 := (lof1 - lof2 + lof3) / Cos(phi1) ;
    _a3 := _a2 * 180 / PI ;

    rec.latitude := 180 * (phi1 - fact1 * (fact2 + fact3 + fact4)) / Pi  ;

    if not northernHemisphere then
        rec.latitude := -rec.latitude  ;

   if (zone > 0) then
     rec.longitude := (6 * zone - 183.0)-_a3
     else  rec.longitude := 3.0-_a3;

    RESULT:= rec   ;
     end;
end.
