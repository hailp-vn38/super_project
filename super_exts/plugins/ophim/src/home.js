async function home(url, page) {
  if (!page) page = 1;

  const res = await Extension.request(url, {
    queryParameters: { page: page },
  });
  if (!res) return Response.error("Có lỗi khi tải nội dung");

  if (!res.status) return Response.error("Có lỗi khi tải nội dung");

  const result = [];

  if (res.items) {
    var pathImage = res.pathImage;
    for (const item of res.items) {
      result.push({
        name: item.name,
        url: "/v1/api/phim/" + item.slug,
        description: "Năm " + item.year,
        cover: pathImage + item.thumb_url,
      });
    }

    return Response.success(result);
  }

  if (res.data && res.data.items) {
    for (const item of res.data.items) {
      result.push({
        name: item.name,
        url: "/v1/api/phim/" + item.slug,
        description: "Năm " + item.year,
        cover: res.data.APP_DOMAIN_CDN_IMAGE + "/" + item.thumb_url,
      });
    }

    return Response.success(result);
  }
}

// runFn(() => home("https://ophim1.com/v1/api/danh-sach/phim-bo"));
