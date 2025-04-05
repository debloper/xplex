import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import starlightImageZoom from 'starlight-image-zoom'

// https://astro.build/config
export default defineConfig({
  site: 'https://xplex.me',
  integrations: [
    starlight({
      plugins: [starlightImageZoom()],
      credits: true,
      title: 'xplex',
      logo: {
        src: './public/favicon.svg',
      },
      tableOfContents: false,
      customCss: [
        './src/styles/custom.css',
      ],
      components: {
        Footer: './src/components/Footer.astro',
      },
      head: [{
        tag: 'meta',
        attrs: {
          property: 'og:image',
          content: 'https://xplex.me/preview.png',
        },
      }],
      social: {
        github: 'https://github.com/debloper/xplex',
      },
      sidebar: [
        {
          label: 'Introduction',
          autogenerate: { directory: 'intro' },
        },
        {
          label: 'How-to Guide',
          autogenerate: { directory: 'setup' },
        },
        {
          label: 'References',
          items: [
            {
              label: 'Choose',
              autogenerate: { directory: 'refs/choose' },
            },
            {
              label: 'Check',
              autogenerate: { directory: 'refs/check' },
            },
            {
              label: 'Change',
              autogenerate: { directory: 'refs/change' },
            },
          ],
        },
        {
          label: 'About',
          autogenerate: { directory: 'about' },
        },
      ],
    }),
  ],
  markdown: {
    // markdown configuration options
  },
  build: {
    // build configuration options
  },
});
