{{flutter_js}}
{{flutter_build_config}}

// No service worker: Flutter's is deprecated, and caching is handled by
// .htaccess so players always get the latest build.
_flutter.loader.load({
  onEntrypointLoaded: async function (engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();
    const el = document.getElementById('loading');
    if (el) el.remove();
  },
});
