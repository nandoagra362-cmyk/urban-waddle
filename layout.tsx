import type {Metadata} from 'next';import './globals.css';
export const metadata:Metadata={title:'AGRA | Gestão de Recebimento de Mercadorias',description:'Conferência e histórico de mercadorias recebidas para farmácias.',icons:{icon:'/agra-identidade.png',shortcut:'/agra-identidade.png'}};
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="pt-BR"><body>{children}</body></html>}
