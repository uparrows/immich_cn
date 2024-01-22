import React from 'react';
import Link from '@docusaurus/Link';
import Layout from '@theme/Layout';

function HomepageHeader() {
  return (
    <header>
      <section className="text-center m-6 p-12 border border-red-400 rounded-[50px] bg-gray-100 dark:bg-immich-dark-gray">
        <img src="img/immich-logo.svg" className="md:h-24 h-12 mb-2" alt="Immich logo" />
        <h1 className="md:text-6xl font-immich-title mb-10 text-immich-primary dark:text-immich-dark-primary uppercase">
          Immich
        </h1>
        <div className="font-thin sm:text-base md:text-2xl my-12 sm:leading-tight">
          <p className="mb-1 uppercase">
            Self-hosted backup solution <span className="block"></span>
            for photos and videos <span className="block"></span>
            on mobile device
          </p>
        </div>

        <div className="flex flex-col sm:flex-row place-items-center place-content-center mt-9 mb-16 gap-4 ">
          <Link
            className="flex place-items-center place-content-center py-3 px-8 border bg-immich-primary dark:bg-immich-dark-primary rounded-full no-underline hover:no-underline text-white hover:text-gray-50 dark:text-immich-dark-bg font-bold uppercase"
            to="docs/overview/introduction"
          >
            Get started
          </Link>

          <Link
            className="flex place-items-center place-content-center py-3 px-8 border bg-immich-primary/10 dark:bg-gray-300  rounded-full hover:no-underline text-immich-primary dark:text-immich-dark-bg font-bold uppercase"
            to="https://demo.immich.app/"
          >
            Demo portal
          </Link>

          <a
            href="https://github.com/sponsors/immich-app"
            target="_blank"
            rel="noreferrer"
            className="flex place-items-center place-content-center py-3 px-8 border bg-immich-sponsor rounded-full no-underline hover:no-underline text-white dark:text-immich-dark-bg dark:bg-immich-sponsor hover:text-white font-bold uppercase"
          >
            Sponsor
          </a>
        </div>

        <img src="/img/immich-screenshots.png" alt="screenshots" width={'85%'} />

        <div className="flex flex-col sm:flex-row place-items-center place-content-center mt-4 gap-1">
          <div className="h-24">
            <a href="https://play.google.com/store/apps/details?id=app.alextran.immich">
              <img className="h-24" alt="Get it on Google Play" src="/img/google-play-badge.png" />
            </a>
          </div>
          <div className="h-24">
            <a href="https://apps.apple.com/sg/app/immich/id1613945652">
              <img className="h-24 sm:p-3.5 p-3" alt="Download on the App Store" src="/img/ios-app-store-badge.svg" />
            </a>
          </div>
        </div>
      </section>
    </header>
  );
}

export default function Home(): JSX.Element {
  return (
    <Layout
      title="Home"
      description="immich Self-hosted photo and video backup solution directly from your mobile phone "
      noFooter={true}
    >
      <HomepageHeader />
      <div className="flex flex-col place-items-center place-content-center">
        <p>This project is available under MIT license.</p>
        <p className="text-xs">Privacy should not be a luxury</p>
      </div>
    </Layout>
  );
}
