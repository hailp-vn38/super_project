async function search(url, kw, page) {
  const res = await Extension.request(url + "/v1/api/tim-kiem", {
    queryParameters: { keyword: kw },
  });
  if (!res) return Response.error("Có lỗi khi tải nội dung");

  if (!res.status == "success") {
    return Response.error("Có lỗi khi tải nội dung");
  }
  const result = [];
  for (const item of res.data.items) {
    result.push({
      name: item.name,
      url: "/v1/api/phim/" + item.slug,
      description: `Năm ${item.year}`,
      cover: res.data.APP_DOMAIN_CDN_IMAGE + "/" + item.thumb_url,
    });
  }
  return Response.success(result);
}

// runFn(() => search("https://ophim1.com", "hậu duệ mặt trời"));
