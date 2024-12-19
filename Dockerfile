FROM mageai/mageai:0.9.74 AS base

ENV LC_ALL en_US.UTF-8

ENV LANG en_US.UTF-8

RUN useradd -s /bin/bash -m docker \
    && usermod -a -G staff docker \
    && apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common dirmngr \
    apt-transport-https ed less locales vim-tiny wget ca-certificates fonts-texgyre \
    libopenblas0-pthread littler \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8 \
    && gpg --keyserver keyserver.ubuntu.com \
    --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' \
    && gpg --armor --export '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' | \
    tee /etc/apt/trusted.gpg.d/cran_debian_key.asc \
    && echo "deb http://cloud.r-project.org/bin/linux/debian bookworm-cran40/" | \
    tee -a /etc/apt/sources.list \
    && apt-get update \
    && apt upgrade r-base-dev r-base r-cran-boot r-cran-codetools r-recommended r-base-core -y \
    && apt-get install -y --no-install-recommends r-cran-littler r-cran-docopt \
    && chown root:staff "/usr/local/lib/R/site-library" \
    && chmod g+ws "/usr/local/lib/R/site-library" \
    && ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
    && ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
    && ln -s /usr/lib/R/site-library/littler/examples/installBioc.r /usr/local/bin/installBioc.r \
    && ln -s /usr/lib/R/site-library/littler/examples/installDeps.r /usr/local/bin/installDeps.r \
    && ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
    && ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/downloaded_packages
