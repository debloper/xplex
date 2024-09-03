import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
  site: 'https://xplex.me',
  integrations: [
    starlight({
      title: 'xplex',
      logo: {
        src: './public/favicon.svg',
      },
      tableOfContents: false,
      customCss: [
        './src/styles/custom.css',
      ],
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
        { slug: 'quick-start' },
        {
          label: 'Introduction',
          items: [
            'intro/index',
            'intro/internals',
          ],
        },
        {
          label: 'How-to Setup',
          autogenerate: { directory: 'setup' },
        },
        {
          label: 'References',
          items: [
            {
              label: 'Choose',
              items: [
                'refs/choose/hosts',
                'refs/choose/clouds',
              ],
            },
            {
              label: 'Check',
              autogenerate: { directory: 'refs/check' },
            },
            {
              label: 'Manage',
              autogenerate: { directory: 'refs/manage' },
            },
          ],
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
