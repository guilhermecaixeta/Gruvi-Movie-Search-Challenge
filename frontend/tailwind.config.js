import { addComponents, addBase } from '@material-tailwind/react/utils';
import Typography from '@material-tailwind/react/theme/components/typography';
import withMT from '@material-tailwind/react/utils/withMT';

/** @type {import('tailwindcss').Config} */
export default {
    content: [
        "./src/**/*.{html,js,svelte,ts}",
        "./node_modules/@material-tailwind/html/**/*.js"
    ],
    theme: {
        extend: {}
    },
    plugins: [
        require('@tailwindcss/forms'),
        addBase(withMT(Typography)),
        addComponents({
            ...Typography,
        }),
    ],
}
