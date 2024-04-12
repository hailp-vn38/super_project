async function home(url, page) {
  if (!page) page = 1;

  const res = await Extension.request(url, {
    queryParameters: { pg: page },
  });
  if (!res) return Response.error("Có lỗi khi tải nội dung");

  const result = [];

  for (const item of res.list) {
    result.push({
      name: item.name,
      url: "/api.php/provide/vod/?ac=detail&ids=" + item.id,
      description: "Năm " + item.year,
      cover: item.thumb_url,
    });
  }

  return Response.success(result);
}

// runFn(() => home("https://avdbapi.com/api.php/provide/vod?ac=detail"));
