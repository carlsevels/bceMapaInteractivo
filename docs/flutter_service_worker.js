'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "87ece3911ee8712c61b3052fd3f5d152",
"version.json": "c1a4d9568c3b9df80ff931621dfbb9a7",
"index.html": "edb5c9831cfc9ee5d0eec8f074c987f4",
"/": "edb5c9831cfc9ee5d0eec8f074c987f4",
"main.dart.js": "6c7bbf289e7448bd4512d4f1c6ff324f",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "e143f933b360fe395ef5632bb3c7a29f",
"assets/salaDeJuntas/imagen1.jpeg": "94e786bcf4f06af34c11274dd52d8286",
"assets/cineInfantil/imagen4.jpeg": "86dd85c84d445583558b90ce71b56994",
"assets/cineInfantil/imagen2.jpeg": "16e00fcfb3bb1268ccb46aece1766198",
"assets/cineInfantil/imagen3.jpeg": "96b2b5179e4e6beaa7ed2712396a1d71",
"assets/cineInfantil/imagen1.jpeg": "6ad3a763557c4f682a3bbeadc321cea6",
"assets/comicteca/imagen2.jpeg": "d22f9da639414ddb9900e31c7a1bcf8b",
"assets/comicteca/imagen1.jpeg": "036010f34a259f7ec646db248383601a",
"assets/inclusion/imagen2.jpeg": "37bea633c076d24b6b8c02669f4df03f",
"assets/inclusion/imagen3.jpeg": "f5721ab1edd1eaa501c0e547cd9e4ef5",
"assets/inclusion/imagen1.jpeg": "6a02721a82fd5a06c96fde50880bf4f8",
"assets/cubiculos/imagen2.jpeg": "17f8db099184f6826f13e3a1551770ac",
"assets/cubiculos/imagen1.jpeg": "087b3796cf7ae4fe1a630ff251aa0988",
"assets/logos/bce.png": "199f5c6bef2b1f6d0030cc159d08f9ba",
"assets/logos/bce2.png": "5a49e8d201d933c6a86a57f66dedb431",
"assets/legadoNL/imagen2.jpeg": "a8cf448bf176ae1f00c79771f21c47be",
"assets/legadoNL/imagen3.jpeg": "7d948cdb2318690a16bebf76b4fa1c9e",
"assets/legadoNL/imagen1.jpeg": "5369880100efb3e721b743005b7f2eb0",
"assets/NOTICES": "e74beb7123918b9c3f9fb2c0edc5341e",
"assets/realidadVirtual/imagen2.jpeg": "cd9558e23bdf5e2479be2127e92b0d0b",
"assets/realidadVirtual/imagen1.jpeg": "b5c4d2a16193db3f90f0337796fb82d3",
"assets/ludoteca/imagen4.jpeg": "1fc94fcdadc566cec4178771a539d714",
"assets/ludoteca/imagen2.jpeg": "883fa17b78efe9827037a8406de0c27b",
"assets/ludoteca/imagen3.jpeg": "d0fbbab1868a6cc910a59520cb4e36e2",
"assets/ludoteca/imagen1.jpeg": "ad451e998b03a785dfe273331fcfa42e",
"assets/acervo/imagen4.jpeg": "84253bc0fb657fc560bafca04748b206",
"assets/acervo/imagen2.jpeg": "95d3940341d1080b34ce8e78e3ed2ee3",
"assets/acervo/imagen3.jpeg": "2791afdb158206d2f1264e6c71158353",
"assets/acervo/imagen1.jpeg": "92ca6d97bdd41390a6f93886528f53c4",
"assets/primeraInfancia/imagen2.jpeg": "d13e796a6990b4f631a4ace2c4466872",
"assets/primeraInfancia/imagen3.jpeg": "86939be70b0508d52e828327c01ae55b",
"assets/primeraInfancia/imagen1.jpeg": "4136d9c7df129ea24689ad1eaf93281e",
"assets/salaJuvenil/imagen4.jpeg": "539c81a691a3a9ead295c0e222362188",
"assets/salaJuvenil/imagen2.jpeg": "4150087d3024ad868fdff9bb87e5c297",
"assets/salaJuvenil/imagen3.jpeg": "600d4924e39485c6a9b4a198c8cfd549",
"assets/salaJuvenil/imagen1.jpeg": "5a6575c4a2011a59911c453d601923e2",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "310980c8e6e53680835e49f23e74734e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/multimedia/imagen2.jpeg": "26f56a271a8a4112c61453641dacd478",
"assets/multimedia/imagen3.jpeg": "60b312e7e92e93e4e36c564375197f03",
"assets/multimedia/imagen1.jpeg": "49086347ad2a6370571f3aa30d6201f1",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/reglamentos/salaJuvenil.png": "6f15f60aa846e323260d1473a580066b",
"assets/reglamentos/multimedia.png": "26e364701a4698b26b27b90ca5e40291",
"assets/reglamentos/salaInfancias.png": "b2f302e7b5bb5c26dea6a72188f8fd6f",
"assets/podcast/imagen2.jpeg": "55427b3eff188f5facf991d43603e004",
"assets/podcast/imagen3.jpeg": "5457e6d3153885d328bc581559fe7795",
"assets/podcast/imagen1.jpeg": "55ece5a57dfccdab0fa1c4cfa39d01db",
"assets/AssetManifest.bin": "0450e48c2a94704c11ab629876e450df",
"assets/multiproposito/imagen2.jpeg": "8de66d7593ee57c1a89bad434b52c4eb",
"assets/multiproposito/imagen1.jpeg": "b4d8b2a7b4d71fcb57c800743909facf",
"assets/fonts/MaterialIcons-Regular.otf": "ef8a8014de12faec3c350831e5ed5dc6",
"assets/modulo/imagen2.jpeg": "f729c0c4b7e3d04d5967420dce809953",
"assets/modulo/imagen1.jpeg": "375a0b1a3af50aa54fa8de17fae705ce",
"assets/assets/salaDeJuntas/imagen1.jpeg": "94e786bcf4f06af34c11274dd52d8286",
"assets/assets/cineInfantil/imagen4.jpeg": "86dd85c84d445583558b90ce71b56994",
"assets/assets/cineInfantil/imagen2.jpeg": "16e00fcfb3bb1268ccb46aece1766198",
"assets/assets/cineInfantil/imagen3.jpeg": "96b2b5179e4e6beaa7ed2712396a1d71",
"assets/assets/cineInfantil/imagen1.jpeg": "6ad3a763557c4f682a3bbeadc321cea6",
"assets/assets/comicteca/imagen2.jpeg": "d22f9da639414ddb9900e31c7a1bcf8b",
"assets/assets/comicteca/imagen1.jpeg": "036010f34a259f7ec646db248383601a",
"assets/assets/inclusion/imagen2.jpeg": "37bea633c076d24b6b8c02669f4df03f",
"assets/assets/inclusion/imagen3.jpeg": "f5721ab1edd1eaa501c0e547cd9e4ef5",
"assets/assets/inclusion/imagen1.jpeg": "6a02721a82fd5a06c96fde50880bf4f8",
"assets/assets/cubiculos/imagen2.jpeg": "17f8db099184f6826f13e3a1551770ac",
"assets/assets/cubiculos/imagen1.jpeg": "087b3796cf7ae4fe1a630ff251aa0988",
"assets/assets/logos/bce.png": "199f5c6bef2b1f6d0030cc159d08f9ba",
"assets/assets/logos/bce2.png": "5a49e8d201d933c6a86a57f66dedb431",
"assets/assets/legadoNL/imagen2.jpeg": "a8cf448bf176ae1f00c79771f21c47be",
"assets/assets/legadoNL/imagen3.jpeg": "7d948cdb2318690a16bebf76b4fa1c9e",
"assets/assets/legadoNL/imagen1.jpeg": "5369880100efb3e721b743005b7f2eb0",
"assets/assets/realidadVirtual/imagen2.jpeg": "cd9558e23bdf5e2479be2127e92b0d0b",
"assets/assets/realidadVirtual/imagen1.jpeg": "b5c4d2a16193db3f90f0337796fb82d3",
"assets/assets/ludoteca/imagen4.jpeg": "1fc94fcdadc566cec4178771a539d714",
"assets/assets/ludoteca/imagen2.jpeg": "883fa17b78efe9827037a8406de0c27b",
"assets/assets/ludoteca/imagen3.jpeg": "d0fbbab1868a6cc910a59520cb4e36e2",
"assets/assets/ludoteca/imagen1.jpeg": "ad451e998b03a785dfe273331fcfa42e",
"assets/assets/acervo/imagen4.jpeg": "84253bc0fb657fc560bafca04748b206",
"assets/assets/acervo/imagen2.jpeg": "95d3940341d1080b34ce8e78e3ed2ee3",
"assets/assets/acervo/imagen3.jpeg": "2791afdb158206d2f1264e6c71158353",
"assets/assets/acervo/imagen1.jpeg": "92ca6d97bdd41390a6f93886528f53c4",
"assets/assets/primeraInfancia/imagen2.jpeg": "d13e796a6990b4f631a4ace2c4466872",
"assets/assets/primeraInfancia/imagen3.jpeg": "86939be70b0508d52e828327c01ae55b",
"assets/assets/primeraInfancia/imagen1.jpeg": "4136d9c7df129ea24689ad1eaf93281e",
"assets/assets/salaJuvenil/imagen4.jpeg": "539c81a691a3a9ead295c0e222362188",
"assets/assets/salaJuvenil/imagen2.jpeg": "4150087d3024ad868fdff9bb87e5c297",
"assets/assets/salaJuvenil/imagen3.jpeg": "600d4924e39485c6a9b4a198c8cfd549",
"assets/assets/salaJuvenil/imagen1.jpeg": "5a6575c4a2011a59911c453d601923e2",
"assets/assets/multimedia/imagen2.jpeg": "26f56a271a8a4112c61453641dacd478",
"assets/assets/multimedia/imagen3.jpeg": "60b312e7e92e93e4e36c564375197f03",
"assets/assets/multimedia/imagen1.jpeg": "49086347ad2a6370571f3aa30d6201f1",
"assets/assets/reglamentos/salaJuvenil.png": "6f15f60aa846e323260d1473a580066b",
"assets/assets/reglamentos/multimedia.png": "26e364701a4698b26b27b90ca5e40291",
"assets/assets/reglamentos/salaInfancias.png": "b2f302e7b5bb5c26dea6a72188f8fd6f",
"assets/assets/podcast/imagen2.jpeg": "55427b3eff188f5facf991d43603e004",
"assets/assets/podcast/imagen3.jpeg": "5457e6d3153885d328bc581559fe7795",
"assets/assets/podcast/imagen1.jpeg": "55ece5a57dfccdab0fa1c4cfa39d01db",
"assets/assets/multiproposito/imagen2.jpeg": "8de66d7593ee57c1a89bad434b52c4eb",
"assets/assets/multiproposito/imagen1.jpeg": "b4d8b2a7b4d71fcb57c800743909facf",
"assets/assets/modulo/imagen2.jpeg": "f729c0c4b7e3d04d5967420dce809953",
"assets/assets/modulo/imagen1.jpeg": "375a0b1a3af50aa54fa8de17fae705ce",
"assets/assets/piso_1.png": "9af5620355e1dcd5893d27146db5466d",
"assets/assets/auditorio/imagen4.jpeg": "594fee60855658b32ef80d7184fa8ecd",
"assets/assets/auditorio/imagen2.jpeg": "6f96e6b717ea02025d13605f92199aec",
"assets/assets/auditorio/imagen3.jpeg": "8c436dbc23b5939b171817736073241b",
"assets/assets/auditorio/imagen1.jpeg": "ae261f7f4d507c6676320198b07d2b42",
"assets/assets/piso_2.png": "8491a87e432d17ca5f7e8ecb1739c7dc",
"assets/assets/mezzanine/imagen2.jpeg": "df87dcc33a3258f08c69e447e6abf01b",
"assets/assets/mezzanine/imagen1.jpeg": "3683768d1aaebf4a14147c548f470022",
"assets/piso_1.png": "9af5620355e1dcd5893d27146db5466d",
"assets/auditorio/imagen4.jpeg": "594fee60855658b32ef80d7184fa8ecd",
"assets/auditorio/imagen2.jpeg": "6f96e6b717ea02025d13605f92199aec",
"assets/auditorio/imagen3.jpeg": "8c436dbc23b5939b171817736073241b",
"assets/auditorio/imagen1.jpeg": "ae261f7f4d507c6676320198b07d2b42",
"assets/piso_2.png": "8491a87e432d17ca5f7e8ecb1739c7dc",
"assets/mezzanine/imagen2.jpeg": "df87dcc33a3258f08c69e447e6abf01b",
"assets/mezzanine/imagen1.jpeg": "3683768d1aaebf4a14147c548f470022",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
