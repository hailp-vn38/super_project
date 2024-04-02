part of 'settings_view.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsCubit _settingsCubit;
  @override
  void initState() {
    _settingsCubit = context.read<SettingsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Settings")),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Socket socket = io(
                      'wss://speech.platform.bing.com/consumer/speech/synthesize/readaloud/edge/v1?TrustedClientToken=6A5AA1D4EAFF4E9FB37E23D68491D6F4&Sec-MS-GEC=C14242292B2241ECB17DD93BD17E481FADED759D70DCE83CA526064D9E90420C&Sec-MS-GEC-Version=1-114.0.1823.67&ConnectionId=373cb9fe3c926de352de8ad4c800b24c HTTP/1.1',
                      OptionBuilder()
                          .setTransports(['wss']) // for Flutter or Dart VM
                          .disableAutoConnect() // disable auto-connection
                          .setExtraHeaders({
                            "Host": "speech.platform.bing.com",
                            "Connection": "Upgrade",
                            "Pragma": "no-cache",
                            "Cache-Control": "no-cache",
                            "User-Agent":
                                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.67",
                            "Upgrade": "websocket",
                            "Origin":
                                "chrome-extension://jdiccldimpdaibmpdkjnbmckianbfold",
                            "Sec-WebSocket-Version": 13,
                            "Accept-Encoding": "gzip, deflate, br",
                            "Accept-Language":
                                "en,zh-CN;q=0.9,zh;q=0.8,en-GB;q=0.7,en-US;q=0.6",
                            "Cookie":
                                "Imported_MUID=279D5D30479A67B120EC4CF8465A66EC; SRCHD=AF=NOFORM; SRCHUID=V=2&GUID=56CF87A361464E7D97109A4DE5068B80&dmnchg=1; MUID=325A63E135A06AAA171571C234606B8E; _tarLang=default=zh-Hans; _TTSS_OUT=hist=WyJ6aC1IYW5zIl0=; MMCASM=ID=DB36A1CCBCE141C988893F7658931D00; ANON=A=BDF919D5061D7F41CCECB893FFFFFFFF&E=1c5e&W=5; NAP=V=1.9&E=1c04&C=3tftpzkAdHnos47AExrgJwTp6Puwum9ieFNAkA8kcyzaw9FsgBNcHA&W=5; PPLState=1; _UR=QS=0&TQS=0; ABDEF=V=13&ABDV=13&MRNB=1685903928257&MRB=0; USRLOC=HS=1&ELOC=LAT=25.30931282043457|LON=110.4037857055664|N=Lingchuan%20County%2C%20Guangxi%20Zhuang|ELT=2|&CLOC=LAT=25.309329051998866|LON=110.40374008805972|A=733.4464586120832|TS=230701173629|SRC=W; KievRPSSecAuth=FAByBBRaTOJILtFsMkpLVWSG6AN6C/svRwNmAAAEgAAACIcO+OPnBnDOMARvQ4a99TLFSEe5qktVEWTUqgPRylgzmpHo0criSIMfmIxbCWKerYz/xckSZ9fIVmh+xtn2waP/f4XRaTroOgRra3Ez3S17ty6xyXVS8sUMoAM/vOjuQMjtyM6ahjmUBda+sjPxekYt/l83dgpaz4zqH9Tto8RPnlsf/4T63XNA/uf48oeq0U2YXKthu5N/guoBTs8tIiBCWqpfKcu8SRgzLx2kBE8XkrzYDBR8cBdOvJuWeUqEiJg0SbGjXYt6FGFEKeYpshDeksDrvJVPij6ymAs0j7PHJVLjM5Tds3AcpBdmWAwNz2yKfLaT9jlIJjtfY6+8Du1BfOvb0noJB00DyF3L7JTnRXdQlRkQG6i3J85gZp5XKfyucptiStnNhwZKYyt5qTz5bFxnZW0Q1DqJnuVMvT0dyLwBV2RUUkeo4IeB6lZtfxthjY2KFe5ZbWpKzECwt22qktDZdYu+tBXlO2rJwDtwKba+gLWP/vBLUAa4hBrRtbuDypx+AHTT9qlxgKY5go0Wz085oPWpq8VxDo1aRiUqXGrqnbJWKzVx50oUnIEJy3DQbxSZzitD6MJ4mmzVbYAyrlwpFtXYO4X7TKvlWnlPstdGdRxykIERl/S3+jp9DBDRCTkXRoFa3VSOkzeuDj0FfDKlQtrQh6Q/GPyCUKy8KRFK3hwxJR7HsE2ivEjMYwdHsfk6hD+Ocw0q1OZT9L5EPkC3XqK0K1JFWuRyDKXmxvjRfazgD1GOszIOvk85MzOXw6uhKHpbLt3vEMX6MkUaFuHSOscFlgYdrP4NIfe/db+48F96hOgY8qLmRfNyRUQZk2oghT7X/Hp8Jjq6KvU30RAzl5VpxlNIHjXg9iBacD46m9zBMCsEt8mie27r0a8plN6T3i/xKVbefueJoa9RE3dDdDaAB3TsLDnKmklSVDR70gPFS4NCCVM2iApD5+TH7nuQ3TvOn0wHOY3AUa2TE41nYA/jiQWdQkXR5q5/p0pQpRMcRyWiGEtydSy+tW/uYoRJs4x0/JdpYrlFjo0skC8Lbin5Fc9mL8+qMlWAF2pCspX2KwQ7ahzeragrLm0KDH41/wFdjiM3POGwF+K/eIKynR1WNwxVFtguiEgPmKo/1IFpl0C20MyKBRtJDt+pRZftYE4fGHS2bB7fb4hCVc9GCTQuirLpvH1oIvRFqOjoka52hVvjm4lWHrOKPKBEns7ab1YuCR9b8VF/fWYrWAmDbCMeLTmWs6Ip8b6d8gm6pxTi1X2l93Hu/gzkT4Xo0eZouRsO5DlO9ARfjDCNwdNy0bSiG4vIJ6ZwPc9WssXxZMHBNRw/cZmoJlS1sOsO437DFm4vQZ45q4LNgrgpNA692EF59vH49QsQDzZikR0GflucdEqlNPUtccYEAmR/i0DEhj3OELuDQY8a3Yk0uvyTncOZaNIWFAD9zf+45bbF2xm/AWoh+ArXEpBQuQ==; WLID=KUYfPWEbNlPRDrYXPelkjmxJvZFv0wz6tT96dilh4DCgLNrpdRPJSpCbu2rfDBmVcuJKl1X4cpPSqjovbW50ggCgqZIzWp683k+1CUJICHs=; SRCHUSR=DOB=20220619&T=1688146375000&TPC=1685734779000&POEX=W; _HPVN=CS=eyJQbiI6eyJDbiI6MTQsIlN0IjowLCJRcyI6MCwiUHJvZCI6IlAifSwiU2MiOnsiQ24iOjE0LCJTdCI6MCwiUXMiOjAsIlByb2QiOiJIIn0sIlF6Ijp7IkNuIjoxNCwiU3QiOjAsIlFzIjowLCJQcm9kIjoiVCJ9LCJBcCI6dHJ1ZSwiTXV0ZSI6dHJ1ZSwiTGFkIjoiMjAyMy0wNi0zMFQwMDowMDowMFoiLCJJb3RkIjowLCJHd2IiOjAsIkRmdCI6bnVsbCwiTXZzIjowLCJGbHQiOjAsIkltcCI6NDN9; SRCHHPGUSR=SRCHLANG=en&BRW=MW&BRH=MT&CW=1902&CH=922&SW=1536&SH=864&DPR=2.8&UTC=480&DM=0&PV=11&WTS=63823445133&BZA=0&PRVCW=393&PRVCH=851&HV=1688146817&SCW=1902&SCH=922&HBOPEN=2; _RwBf=ilt=5&ihpd=1&ispd=0&rc=30&rb=30&gb=0&rg=0&pc=30&mtu=0&rbb=0.0&g=0&cid=&clo=0&v=4&l=2023-06-30T07:00:00.0000000Z&lft=0001-01-01T00:00:00.0000000&aof=0&o=0&p=bingcopilotwaitlist&c=MY00IA&t=8305&s=2023-02-19T09:46:05.9860389+00:00&ts=2023-06-30T17:39:35.7692651+00:00&rwred=0&wls=2&lka=0&lkt=0&TH=&mta=0&e=1FouwS5GVXBVl-SkUiOwiZzt0OE6NrGp9VOEBUZVm8_C_dS7_q_nvq-yiW1bzUP-KIXibyq2kf5HkqCbVM7EGg&A=BDF919D5061D7F41CCECB893FFFFFFFF&dci=0; SUID=A; WLS=C=aa4e6de0bbbb2fd0&N=lizan; _SS=SID=1A9307EC7FD662F3261514AD7E0F63C8; _U=10tbPuGOdzPNMte05ZF-7PujpfTktYWP5vffV0QlYXYElxiZIenSCz69Wr4_EmJH3DEPDT1ewxutXE28f8BucrmvsUMM_dYx23lrl6ia2XHR-B6dZ9TBlLRw-dFn9KqwXmaY6ozCPvW5bvnayy9h5AQpSwxa50xkfSZhxivIgiaQWz6fx0JAdT4mAQSoaumIW1cJZi3gR5nRXxe4x2uJJ5Q",
                            "Sec-WebSocket-Key": "BgvTFvtUpQzEgl0tGl/iNg==",
                            "Sec-WebSocket-Extensions":
                                "permessage-deflate; client_max_window_bits"
                          }) // optional
                          .build());
                  final tmp = socket.connect();
                  socket.onConnect((data) {
                    print("object");
                  });
                  socket.onError((data) {
                    print("err");
                    print(data);
                  });
                },
                child: const Text("ok")),
            ElevatedButton(
                onPressed: () async {
                  Uri wsUrl = Uri.parse(
                      'wss://speech.platform.bing.com/consumer/speech/synthesize/readaloud/edge/v1?TrustedClientToken=6A5AA1D4EAFF4E9FB37E23D68491D6F4&Sec-MS-GEC=C14242292B2241ECB17DD93BD17E481FADED759D70DCE83CA526064D9E90420C&Sec-MS-GEC-Version=1-114.0.1823.67&ConnectionId=373cb9fe3c926de352de8ad4c800b24c HTTP/1.1');
                  wsUrl = wsUrl.replace(queryParameters: {
                    "Host": "speech.platform.bing.com",
                    "Connection": "Upgrade",
                    "Pragma": "no-cache",
                    "Cache-Control": "no-cache",
                    "User-Agent":
                        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.67",
                    "Upgrade": "websocket",
                    "Origin":
                        "chrome-extension://jdiccldimpdaibmpdkjnbmckianbfold",
                    "Sec-WebSocket-Version": "13",
                    "Accept-Encoding": "gzip, deflate, br",
                    "Accept-Language":
                        "en,zh-CN;q=0.9,zh;q=0.8,en-GB;q=0.7,en-US;q=0.6",
                    "Cookie":
                        "Imported_MUID=279D5D30479A67B120EC4CF8465A66EC; SRCHD=AF=NOFORM; SRCHUID=V=2&GUID=56CF87A361464E7D97109A4DE5068B80&dmnchg=1; MUID=325A63E135A06AAA171571C234606B8E; _tarLang=default=zh-Hans; _TTSS_OUT=hist=WyJ6aC1IYW5zIl0=; MMCASM=ID=DB36A1CCBCE141C988893F7658931D00; ANON=A=BDF919D5061D7F41CCECB893FFFFFFFF&E=1c5e&W=5; NAP=V=1.9&E=1c04&C=3tftpzkAdHnos47AExrgJwTp6Puwum9ieFNAkA8kcyzaw9FsgBNcHA&W=5; PPLState=1; _UR=QS=0&TQS=0; ABDEF=V=13&ABDV=13&MRNB=1685903928257&MRB=0; USRLOC=HS=1&ELOC=LAT=25.30931282043457|LON=110.4037857055664|N=Lingchuan%20County%2C%20Guangxi%20Zhuang|ELT=2|&CLOC=LAT=25.309329051998866|LON=110.40374008805972|A=733.4464586120832|TS=230701173629|SRC=W; KievRPSSecAuth=FAByBBRaTOJILtFsMkpLVWSG6AN6C/svRwNmAAAEgAAACIcO+OPnBnDOMARvQ4a99TLFSEe5qktVEWTUqgPRylgzmpHo0criSIMfmIxbCWKerYz/xckSZ9fIVmh+xtn2waP/f4XRaTroOgRra3Ez3S17ty6xyXVS8sUMoAM/vOjuQMjtyM6ahjmUBda+sjPxekYt/l83dgpaz4zqH9Tto8RPnlsf/4T63XNA/uf48oeq0U2YXKthu5N/guoBTs8tIiBCWqpfKcu8SRgzLx2kBE8XkrzYDBR8cBdOvJuWeUqEiJg0SbGjXYt6FGFEKeYpshDeksDrvJVPij6ymAs0j7PHJVLjM5Tds3AcpBdmWAwNz2yKfLaT9jlIJjtfY6+8Du1BfOvb0noJB00DyF3L7JTnRXdQlRkQG6i3J85gZp5XKfyucptiStnNhwZKYyt5qTz5bFxnZW0Q1DqJnuVMvT0dyLwBV2RUUkeo4IeB6lZtfxthjY2KFe5ZbWpKzECwt22qktDZdYu+tBXlO2rJwDtwKba+gLWP/vBLUAa4hBrRtbuDypx+AHTT9qlxgKY5go0Wz085oPWpq8VxDo1aRiUqXGrqnbJWKzVx50oUnIEJy3DQbxSZzitD6MJ4mmzVbYAyrlwpFtXYO4X7TKvlWnlPstdGdRxykIERl/S3+jp9DBDRCTkXRoFa3VSOkzeuDj0FfDKlQtrQh6Q/GPyCUKy8KRFK3hwxJR7HsE2ivEjMYwdHsfk6hD+Ocw0q1OZT9L5EPkC3XqK0K1JFWuRyDKXmxvjRfazgD1GOszIOvk85MzOXw6uhKHpbLt3vEMX6MkUaFuHSOscFlgYdrP4NIfe/db+48F96hOgY8qLmRfNyRUQZk2oghT7X/Hp8Jjq6KvU30RAzl5VpxlNIHjXg9iBacD46m9zBMCsEt8mie27r0a8plN6T3i/xKVbefueJoa9RE3dDdDaAB3TsLDnKmklSVDR70gPFS4NCCVM2iApD5+TH7nuQ3TvOn0wHOY3AUa2TE41nYA/jiQWdQkXR5q5/p0pQpRMcRyWiGEtydSy+tW/uYoRJs4x0/JdpYrlFjo0skC8Lbin5Fc9mL8+qMlWAF2pCspX2KwQ7ahzeragrLm0KDH41/wFdjiM3POGwF+K/eIKynR1WNwxVFtguiEgPmKo/1IFpl0C20MyKBRtJDt+pRZftYE4fGHS2bB7fb4hCVc9GCTQuirLpvH1oIvRFqOjoka52hVvjm4lWHrOKPKBEns7ab1YuCR9b8VF/fWYrWAmDbCMeLTmWs6Ip8b6d8gm6pxTi1X2l93Hu/gzkT4Xo0eZouRsO5DlO9ARfjDCNwdNy0bSiG4vIJ6ZwPc9WssXxZMHBNRw/cZmoJlS1sOsO437DFm4vQZ45q4LNgrgpNA692EF59vH49QsQDzZikR0GflucdEqlNPUtccYEAmR/i0DEhj3OELuDQY8a3Yk0uvyTncOZaNIWFAD9zf+45bbF2xm/AWoh+ArXEpBQuQ==; WLID=KUYfPWEbNlPRDrYXPelkjmxJvZFv0wz6tT96dilh4DCgLNrpdRPJSpCbu2rfDBmVcuJKl1X4cpPSqjovbW50ggCgqZIzWp683k+1CUJICHs=; SRCHUSR=DOB=20220619&T=1688146375000&TPC=1685734779000&POEX=W; _HPVN=CS=eyJQbiI6eyJDbiI6MTQsIlN0IjowLCJRcyI6MCwiUHJvZCI6IlAifSwiU2MiOnsiQ24iOjE0LCJTdCI6MCwiUXMiOjAsIlByb2QiOiJIIn0sIlF6Ijp7IkNuIjoxNCwiU3QiOjAsIlFzIjowLCJQcm9kIjoiVCJ9LCJBcCI6dHJ1ZSwiTXV0ZSI6dHJ1ZSwiTGFkIjoiMjAyMy0wNi0zMFQwMDowMDowMFoiLCJJb3RkIjowLCJHd2IiOjAsIkRmdCI6bnVsbCwiTXZzIjowLCJGbHQiOjAsIkltcCI6NDN9; SRCHHPGUSR=SRCHLANG=en&BRW=MW&BRH=MT&CW=1902&CH=922&SW=1536&SH=864&DPR=2.8&UTC=480&DM=0&PV=11&WTS=63823445133&BZA=0&PRVCW=393&PRVCH=851&HV=1688146817&SCW=1902&SCH=922&HBOPEN=2; _RwBf=ilt=5&ihpd=1&ispd=0&rc=30&rb=30&gb=0&rg=0&pc=30&mtu=0&rbb=0.0&g=0&cid=&clo=0&v=4&l=2023-06-30T07:00:00.0000000Z&lft=0001-01-01T00:00:00.0000000&aof=0&o=0&p=bingcopilotwaitlist&c=MY00IA&t=8305&s=2023-02-19T09:46:05.9860389+00:00&ts=2023-06-30T17:39:35.7692651+00:00&rwred=0&wls=2&lka=0&lkt=0&TH=&mta=0&e=1FouwS5GVXBVl-SkUiOwiZzt0OE6NrGp9VOEBUZVm8_C_dS7_q_nvq-yiW1bzUP-KIXibyq2kf5HkqCbVM7EGg&A=BDF919D5061D7F41CCECB893FFFFFFFF&dci=0; SUID=A; WLS=C=aa4e6de0bbbb2fd0&N=lizan; _SS=SID=1A9307EC7FD662F3261514AD7E0F63C8; _U=10tbPuGOdzPNMte05ZF-7PujpfTktYWP5vffV0QlYXYElxiZIenSCz69Wr4_EmJH3DEPDT1ewxutXE28f8BucrmvsUMM_dYx23lrl6ia2XHR-B6dZ9TBlLRw-dFn9KqwXmaY6ozCPvW5bvnayy9h5AQpSwxa50xkfSZhxivIgiaQWz6fx0JAdT4mAQSoaumIW1cJZi3gR5nRXxe4x2uJJ5Q",
                    "Sec-WebSocket-Key": " BgvTFvtUpQzEgl0tGl/iNg==",
                    "Sec-WebSocket-Extensions":
                        "permessage-deflate; client_max_window_bits"
                  });
                  final channel = WebSocketChannel.connect(wsUrl);

                  await channel.ready;

                  channel.stream.listen((message) {
                    channel.sink.add('received!');
                    // channel.sink.close(status.goingAway);
                  });
                },
                child: Text("Conntect"))
          ],
        ));
  }
}
