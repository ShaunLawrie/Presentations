"""
Setup file for the enterprise flake8 plugin.
"""
from setuptools import setup

setup(
    name='flake8-enterprise',
    version='1.0.0',
    description='Enterprise coding standards for Python',
    py_modules=['flake8_enterprise_plugin'],
    install_requires=['flake8>=6.0.0'],
    entry_points={
        'flake8.extension': [
            'ENT4 = flake8_enterprise_plugin:EnterpriseChecker',
        ],
    },
    classifiers=[
        'Framework :: Flake8',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
    ],
)
