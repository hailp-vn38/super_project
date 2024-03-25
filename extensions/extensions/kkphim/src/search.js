async function search(url, kw, page) {
  const res = await Extension.request(url + "/v1/api/tim-kiem", {
    queryParameters: { keyword: kw, limit: 100 },
  });
  if (!res) return Response.error("Có lỗi khi tải nội dung");

  if (!res.status == "success") {
    return Response.error("Có lỗi khi tải nội dung");
  }
  const result = [];
  for (const item of res.data.items) {
    result.push({
      name: item.name,
      url: "/phim/" + item.slug,
      description: `$item.year`,
      cover: res.data.APP_DOMAIN_CDN_IMAGE + "/" + item.poster_url,
    });
  }
  return Response.success(result);
}

// runFn(() => search("https://phimapi.com", "usa"));
